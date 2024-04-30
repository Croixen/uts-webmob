<?php
require '../database.php';

header('Content-type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");

if ($_SERVER['REQUEST_METHOD'] === "POST") {
    if (isset($_GET['pinjamBuku'])) {
        $json = file_get_contents('php://input');
        $data = json_decode($json, true);
    
        // Pastikan data yang dibutuhkan tersedia
        if (isset($data['namaPeminjam']) && isset($data['ISBN']) && isset($data['tanggalPeminjaman'])) {
            $namaPeminjam = $data['namaPeminjam'];
            $ISBN = $data['ISBN'];
            $tanggalPeminjaman = $data['tanggalPeminjaman'];
    
            // Check apakah buku dengan ISBN yang sama ada di database buku
            $check_book_stmt = mysqli_prepare($conn, "SELECT COUNT(*) AS bookCount FROM `buku` WHERE `ISBN` = ?");
            mysqli_stmt_bind_param($check_book_stmt, "s", $ISBN);
            mysqli_stmt_execute($check_book_stmt);
            $book_result = mysqli_stmt_get_result($check_book_stmt);
            $book_row = mysqli_fetch_assoc($book_result);
            $availableBooks = $book_row['bookCount'];
    
            if ($availableBooks == 0) {
                // Buku dengan ISBN yang diberikan tidak ada dalam database buku
                http_response_code(404);
                $response = array('error' => 'Buku dengan ISBN yang diberikan tidak ada.');
                echo json_encode($response);
            } else {
                // Buku ada dalam database, lanjutkan untuk memeriksa apakah sudah dipinjam atau belum
                $check_stmt = mysqli_prepare($conn, "SELECT COUNT(*) AS count FROM `pinjamkembali` WHERE `ISBN` = ? AND `tanggalPengembalian` IS NULL");
                mysqli_stmt_bind_param($check_stmt, "s", $ISBN);
                mysqli_stmt_execute($check_stmt);
                $result = mysqli_stmt_get_result($check_stmt);
                $row = mysqli_fetch_assoc($result);
                $bookCount = $row['count'];
    
                if ($bookCount > 0) {
                    // Buku sudah dipinjam dan belum dikembalikan
                    http_response_code(400);
                    $response = array('error' => 'Buku dengan ISBN yang sama sudah dipinjam.');
                    echo json_encode($response);
                } else {
                    // Lakukan operasi untuk memasukkan data pinjaman ke dalam database
                    $stmt = mysqli_prepare($conn, "INSERT INTO `pinjamkembali`(`namaPeminjam`, `ISBN`, `tanggalPeminjaman`) VALUES (?,?,?)");
    
                    if ($stmt) {
                        mysqli_stmt_bind_param($stmt, "sss", $namaPeminjam, $ISBN, $tanggalPeminjaman);
                        mysqli_stmt_execute($stmt);
    
                        $new_loan_id = mysqli_insert_id($conn);
                        $response = array('namaPeminjam' => $new_loan_id);
                        echo json_encode($response);
                    } else {
                        http_response_code(500);
                        $response = array('error' => 'Database error');
                        echo json_encode($response);
                    }
    
                    mysqli_stmt_close($stmt);
                }
            }
        } else {
            http_response_code(400);
            $response = array('error' => 'Invalid data format');
            echo json_encode($response);
        }
    }
    
    
    
}
?>

<?php
require '../database.php';

header('Content-type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (isset($_GET['daftarPinjaman'])) {
        // Query untuk mengambil daftar pinjaman beserta informasi buku
        $query = "SELECT pinjamkembali.ISBN, pinjamkembali.namaPeminjam, pinjamkembali.idPinjam, pinjamkembali.tanggalPeminjaman, pinjamkembali.tanggalPengembalian, pinjamkembali.penalty, pinjamkembali.selesai, buku.judulBuku 
                  FROM pinjamkembali 
                  INNER JOIN buku ON pinjamkembali.ISBN = buku.ISBN";

        $result = mysqli_query($conn, $query);

        if ($result) {
            $loanList = array();

            while ($row = mysqli_fetch_assoc($result)) {
                $loanList[] = array(
                    'idPinjam' => $row['idPinjam'],
                    'ISBN' => $row['ISBN'],
                    'namaPeminjam' => $row['namaPeminjam'],
                    'tanggalPeminjaman' => $row['tanggalPeminjaman'],
                    'tanggalPengembalian' => $row['tanggalPengembalian'],
                    'penalty' => $row['penalty'],
                    'selesai' => $row['selesai'],
                    'judulBuku' => $row['judulBuku']
                );
            }

            echo json_encode($loanList);
        } else {
            http_response_code(500);
            $response = array('error' => 'Database error');
            echo json_encode($response);
        }

        mysqli_free_result($result);
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    if (isset($_GET['updatePengembalian'])) {
        $json = file_get_contents('php://input');
        $data = json_decode($json, true);
        var_dump($data['tanggalPengembalian']);
        var_dump($data['idPinjam']);

        // Pastikan data yang dibutuhkan tersedia
        if (isset($data['idPinjam']) && isset($data['tanggalPengembalian'])) {
            $idPinjam = $data['idPinjam'];
            $tanggalPengembalian = $data['tanggalPengembalian'];

            // Hitung selisih hari antara tanggal peminjaman dan tanggal pengembalian
            $query = "SELECT tanggalPeminjaman FROM pinjamkembali WHERE idPinjam = ?";
            $stmt = mysqli_prepare($conn, $query);
            mysqli_stmt_bind_param($stmt, "i", $idPinjam);
            mysqli_stmt_execute($stmt);
            mysqli_stmt_bind_result($stmt, $tanggalPeminjaman);
            mysqli_stmt_fetch($stmt);

            $dateDiff = date_diff(date_create($tanggalPeminjaman), date_create($tanggalPengembalian));
            $daysDifference = $dateDiff->format("%a");

            $penalty = ($daysDifference > 3) ? 1 : 0;

            mysqli_stmt_close($stmt);

            // Update tanggal pengembalian, penalty, dan selesai dalam database
            $updateQuery = "UPDATE pinjamkembali SET tanggalPengembalian = ?, penalty = ?, selesai = ? WHERE idPinjam = ?";
            $updateStmt = mysqli_prepare($conn, $updateQuery);

            if ($updateStmt) {
                $selesai = 1;

                mysqli_stmt_bind_param($updateStmt, "siii", $tanggalPengembalian, $penalty, $selesai, $idPinjam);
                mysqli_stmt_execute($updateStmt);

                if (mysqli_stmt_affected_rows($updateStmt) > 0) {
                    $response = array('success' => 'Data updated successfully');
                    echo json_encode($response);
                } else {
                    http_response_code(500);
                    $response = array('error' => 'Failed to update data');
                    echo json_encode($response);
                }

                mysqli_stmt_close($updateStmt);
            } else {
                http_response_code(500);
                $response = array('error' => 'Database error');
                echo json_encode($response);
            }
        } else {
            http_response_code(400);
            $response = array('error' => 'Invalid data format.');
            echo json_encode($response);
        }
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    if (isset($_GET['deletePengembalian'])) {
        $json = file_get_contents('php://input');
        $data = json_decode($json, true);

        if (isset($data['idPinjam'])){
            $idPinjam = $data['idPinjam'];
            try{
                $query = "DELETE FROM pinjamkembali WHERE idPinjam = ? LIMIT 1";
                $Deletestmt = mysqli_prepare($conn, $query);
                mysqli_stmt_bind_param($Deletestmt, 'i', $idPinjam); // Assuming idPinjam is an integer
                mysqli_stmt_execute($Deletestmt);
                if(mysqli_stmt_affected_rows($Deletestmt) > 0){
                    http_response_code(200);
                    echo json_encode(array('msg' => 'sukses'));
                }else{
                    http_response_code(400);
                    echo json_encode(array('msg' => 'gagal'));
                }
            }catch(Exception $e){
                http_response_code(500);
                echo json_encode(array('err' => $e));
            }
            
            
        }
    }
}
?>

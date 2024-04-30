<?php
require '../database.php';

header('Content-type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");

if ($_SERVER['REQUEST_METHOD'] === "POST") {
    if (isset($_GET['addBook'])) {
        $json = file_get_contents('php://input');
        $data = json_decode($json, true);

        if (isset($data['image']) && isset($data['judulbuku']) && isset($data['isbn'])) {
            $imageData = $data['image'];
            $judulBuku = $data['judulbuku'];
            $isbn = $data['isbn'];

            // Check if ISBN already exists
            $stmt_check = mysqli_prepare($conn, "SELECT COUNT(*) FROM buku WHERE ISBN = ?");
            mysqli_stmt_bind_param($stmt_check, "s", $isbn);
            mysqli_stmt_execute($stmt_check);
            mysqli_stmt_bind_result($stmt_check, $isbnCount);
            mysqli_stmt_fetch($stmt_check);
            mysqli_stmt_close($stmt_check);

            if ($isbnCount > 0) {
                http_response_code(400);
                $response = array('error' => 'Duplicate ISBN');
                echo json_encode($response);
            } else {
                $imageData = str_replace('data:image/png;base64,', '', $imageData);
                $imageData = str_replace(' ', '+', $imageData);
                $imageDecoded = base64_decode($imageData);

                $imageName = uniqid() . '.png';
                $imagePath = "../static/buku/" . $imageName;

                if (file_put_contents($imagePath, $imageDecoded)) {
                    $stmt = mysqli_prepare($conn, "INSERT INTO buku (`gambar`, `judulBuku`, `ISBN`) VALUES (?, ?, ?)");

                    if ($stmt) {
                        mysqli_stmt_bind_param($stmt, "sss", $imageName, $judulBuku, $isbn);
                        mysqli_stmt_execute($stmt);

                        $newBookId = mysqli_insert_id($conn);
                        $response = array('id' => $newBookId);
                        echo json_encode($response);
                    } else {
                        http_response_code(500);
                        $response = array('error' => 'Database error');
                        echo json_encode($response);
                    }

                    mysqli_stmt_close($stmt);
                } else {
                    http_response_code(500);
                    $response = array('error' => 'Failed to save image');
                    echo json_encode($response);
                }
            }
        } else {
            http_response_code(400);
            $response = array('error' => 'Invalid data format');
            echo json_encode($response);
        }
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (isset($_GET['getAllBooks'])) {
        $stmt = mysqli_prepare($conn, "SELECT DISTINCT buku.gambar, buku.judulBuku, buku.ISBN
        FROM buku
        LEFT JOIN (
            SELECT ISBN
            FROM pinjamkembali
            WHERE selesai = 0 OR selesai IS NULL
        ) AS borrowed_books ON buku.ISBN = borrowed_books.ISBN
        WHERE borrowed_books.ISBN IS NULL
        
        ");

        if ($stmt) {
            mysqli_stmt_execute($stmt);
            mysqli_stmt_store_result($stmt);

            if (mysqli_stmt_num_rows($stmt) > 0) {
                mysqli_stmt_bind_result($stmt, $gambar, $judulBuku, $ISBN);

                $books = array();

                while (mysqli_stmt_fetch($stmt)) {
                    $book = array(
                        'gambar' => $gambar,
                        'judulBuku' => $judulBuku,
                        'ISBN' => $ISBN
                    );

                    $books[] = $book;
                }

                echo json_encode($books);
            } else {
                http_response_code(404);
                $response = array('error' => 'No books found');
                echo json_encode($response);
            }

            mysqli_stmt_close($stmt);
        } else {
            http_response_code(500);
            $response = array('error' => 'Database error');
            echo json_encode($response);
        }
    }
}

if (isset($_GET['getBookImage'])) {
    if (isset($_GET['img'])) {
        $imgName = $_GET['img'];
        $filePath = "../static/buku/$imgName";
        header('Content-Type: image/jpeg');

        if (file_exists($filePath)) {
            echo file_get_contents($filePath);
            exit;
        } else {
            echo file_get_contents('../static/image/toppng.com-donna-picarro-dummy-avatar-768x768.png');
            exit;
        }
    } else {
        echo 'No image parameter specified';
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    parse_str(file_get_contents("php://input"), $_DELETE);

    if (isset($_GET['deleteBook'])) {
        $data = $_DELETE;

        if (isset($data['isbn'])) {
            $isbn = $data['isbn'];

            $stmt = mysqli_prepare($conn, "DELETE FROM buku WHERE ISBN = ?");

            if ($stmt) {
                mysqli_stmt_bind_param($stmt, "s", $isbn);
                mysqli_stmt_execute($stmt);

                $affectedRows = mysqli_stmt_affected_rows($stmt);

                if ($affectedRows > 0) {
                    $response = array('success' => 'Book deleted successfully');
                    echo json_encode($response);
                } else {
                    http_response_code(404);
                    $response = array('error' => 'Book not found or already deleted');
                    echo json_encode($response);
                }

                mysqli_stmt_close($stmt);
            } else {
                http_response_code(500);
                $response = array('error' => 'Database error');
                echo json_encode($response);
            }
        } else {
            http_response_code(400);
            $response = array('error' => 'Invalid data format');
            echo json_encode($response);
        }
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    if (isset($_GET['hapusBuku'])) {
        $json = file_get_contents('php://input');
        $data = json_decode($json, true);

        if (isset($data['isbn'])){
            $isbn = $data['isbn'];
            try{
                $query = "DELETE FROM buku WHERE ISBN = ? LIMIT 1";
                $Deletestmt = mysqli_prepare($conn, $query);
                mysqli_stmt_bind_param($Deletestmt, 'i', $isbn); // Assuming idPinjam is an integer
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
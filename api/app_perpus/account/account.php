<?php
require '../database.php';

header('Content-type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");

if ($_SERVER['REQUEST_METHOD'] === "POST") {
    if (isset($_GET['login'])) {
        $json = file_get_contents('php://input');
        $data = json_decode($json, true);

        if (isset($data['email']) && isset($data['password'])) {
            $email = $data['email'];
            $password = $data['password'];
            $stmt = mysqli_prepare($conn, "SELECT id FROM akun WHERE `email` = ? AND `password` = ? LIMIT 1");

            if ($stmt) {
                mysqli_stmt_bind_param($stmt, "ss", $email, $password); // Change $username to $email
                mysqli_stmt_execute($stmt);
                mysqli_stmt_store_result($stmt);

                if (mysqli_stmt_num_rows($stmt) > 0) {
                    mysqli_stmt_bind_result($stmt, $id);
                    mysqli_stmt_fetch($stmt);

                    $response = array('id' => $id);
                    echo json_encode($response);
                } else {
                    http_response_code(401);
                    $response = array('error' => 'Unauthorized');
                    echo json_encode($response);
                    exit(); // Exit after setting the response code
                }

                mysqli_stmt_close($stmt);
            } else {
                http_response_code(500); 
                $response = array('error' => 'Database error');
                echo json_encode($response);
                exit(); 
            }
        } else {
          
            http_response_code(400); 
            $response = array('error' => 'Invalid data format');
            echo json_encode($response);
            exit();
        }
    }


    else if (isset($_GET['newAccount'])) {
        $email = $_POST['email'];
        $password = $_POST['password'];
        $nama = $_POST['nama']; 

        
        $check_stmt = mysqli_prepare($conn, "SELECT id FROM akun WHERE `email` = ?");
        mysqli_stmt_bind_param($check_stmt, "s", $email);
        mysqli_stmt_execute($check_stmt);
        mysqli_stmt_store_result($check_stmt);

        if (mysqli_stmt_num_rows($check_stmt) > 0) {
            http_response_code(409); 
            $response = array('error' => 'Email already exists');
            echo json_encode($response);
            exit();
        }

        mysqli_stmt_close($check_stmt);

        
        $create_stmt = mysqli_prepare($conn, "INSERT INTO akun (`email`, `password`, `nama`) VALUES (?, ?, ?)");

        if ($create_stmt) {
            mysqli_stmt_bind_param($create_stmt, "sss", $email, $password, $nama);
            mysqli_stmt_execute($create_stmt);

            $new_account_id = mysqli_insert_id($conn);
            $response = array('id' => $new_account_id);
            echo json_encode($response);
        } else {
            http_response_code(500);
            $response = array('error' => 'Database error');
            echo json_encode($response);
        }

        mysqli_stmt_close($create_stmt);
    }

}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (isset($_GET['getAkun'])) {
        $id = $_GET['getAkun'];
        $stmt = mysqli_prepare($conn, "SELECT email, `password`, tanggal_masuk, tanggal_lahir, nama, gambar FROM akun WHERE id = ?");

        if ($stmt) {
            mysqli_stmt_bind_param($stmt, "i", $id); 
            mysqli_stmt_execute($stmt);
            mysqli_stmt_store_result($stmt);

            if (mysqli_stmt_num_rows($stmt) > 0) {
                mysqli_stmt_bind_result($stmt, $email, $password, $tanggal_masuk, $tanggal_lahir, $nama, $gambar);
                mysqli_stmt_fetch($stmt);

                $response = array(
                    'email' => $email,
                    'password' => $password,
                    'tanggal_masuk' => $tanggal_masuk,
                    'tanggal_lahir' => $tanggal_lahir,
                    'nama' => $nama,
                    'gambar' => $gambar
                );

                echo json_encode($response);
            } else {
                http_response_code(404); 
                $response = array('error' => 'User not found');
                echo json_encode($response);
            }

            mysqli_stmt_close($stmt);
        } else {
            http_response_code(500); 
            $response = array('error' => 'Database error');
            echo json_encode($response);
        }
    }

    if (isset($_GET['GetPic'])) {
        if (isset($_GET['img'])) {
            $imgName = $_GET['img'];
            $filePath = "../static/image/$imgName";
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
}

if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    if (isset($_GET['EditProfile'])) {
        $json = file_get_contents('php://input');
        $data = json_decode($json, true);

        
        if (isset($data['gambar']) && !empty($data['gambar'])) {
            $imgData = $data['gambar'];

            
            $imgData = str_replace('data:image/png;base64,', '', $imgData);
            $imgData = str_replace(' ', '+', $imgData);

            
            $imgDecoded = base64_decode($imgData);

       
            $imgFileName = uniqid() . '.png'; 

            $imgPath = "../static/image/" . $imgFileName;

            file_put_contents($imgPath, $imgDecoded);

            $id = $data['id']; 
            $nama = $data['Nama'];
            $tanggalLahir = $data['tanggalLahir'];
            $email = $data['email'];

            $updateProfileQuery = "UPDATE akun SET nama = ?, tanggal_lahir = ?, email = ?, gambar = ? WHERE id = ?";

            $stmt = mysqli_prepare($conn, $updateProfileQuery);

            mysqli_stmt_bind_param($stmt, "ssssi", $nama, $tanggalLahir, $email, $imgFileName, $id);
            mysqli_stmt_execute($stmt);
            if (mysqli_stmt_affected_rows($stmt) > 0) {

                $response = array('success' => 'Profile updated successfully');
                echo json_encode($response);
            } else {
                
                $response = array('error' => 'Failed to update profile');
                echo json_encode($response);
            }

            mysqli_stmt_close($stmt);
        } else {
            $id = $data['id']; 
            $nama = $data['Nama'];
            $tanggalLahir = $data['tanggalLahir'];
            $email = $data['email'];

            
            $updateProfileQuery = "UPDATE akun SET nama = ?, tanggal_lahir = ?, email = ? WHERE id = ?";

            
            $stmt = mysqli_prepare($conn, $updateProfileQuery);

            
            mysqli_stmt_bind_param($stmt, "sssi", $nama, $tanggalLahir, $email, $id);
            mysqli_stmt_execute($stmt);

            
            if (mysqli_stmt_affected_rows($stmt) > 0) {
                
                $response = array('success' => 'Profile updated successfully');
                echo json_encode($response);
            } else {
                
                $response = array('error' => 'Failed to update profile');
                echo json_encode($response);
            }

            mysqli_stmt_close($stmt);
        }

    }
}

if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    if (isset($_GET['HapusProfile'])) {
        $json = file_get_contents('php://input');
        $data = json_decode($json, true);

        if (isset($data['id'])) {
            $id = $data['id'];
            $stmt = mysqli_prepare($conn, 'DELETE FROM akun WHERE id = ? LIMIT 1');
            mysqli_stmt_bind_param($stmt, 'i', $id);
            try{
                mysqli_stmt_execute($stmt);
                if(mysqli_stmt_affected_rows($stmt) == 0){
                    http_response_code(400);
                    echo json_encode(array('message' => "Tidak ditemukan akun dengan id tersebut"));
                }
                else{
                    echo json_encode(array('message' => 'Akun berhasil terhapus'));
                }
            }catch (Exception $e){
                http_response_code(400);
                echo json_encode(array('message' => "terjadi kesalahan"));
            }
            mysqli_stmt_close($stmt);
        }else{
            http_response_code(500);
            echo json_encode(array('message' => "Terjadi kesalahan terhadap body request"));
        }

    }
}

?>
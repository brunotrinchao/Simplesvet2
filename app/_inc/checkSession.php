<?php

function returnLogin(){
    if(!isset($_SESSION['ses_simplesvet'])){
        header('Location: login.php');
    }
}

function goIndex(){
    
    if(isset($_SESSION['ses_simplesvet'])){
        header('Location: index.php');
    }
}



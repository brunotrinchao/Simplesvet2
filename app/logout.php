<?php
session_start();

unset($_SESSION['ses_simplesvet']);
header('Location: login.php');
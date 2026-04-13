<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Connexion - SGDA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body>
<div class="container">
    <div class="panel login-card">
        <h1>Connexion SGDA</h1>
        <jsp:include page="/WEB-INF/views/common/flash.jsp"/>
        <form method="post" action="${pageContext.request.contextPath}/login">
            <div class="form-row">
                <label for="login">Email ou username</label>
                <input id="login" name="login" type="text" required>
            </div>
            <div class="form-row">
                <label for="password">Mot de passe</label>
                <input id="password" name="password" type="password" required>
            </div>
            <button class="btn btn-primary" type="submit">Se connecter</button>
        </form>
    </div>
</div>
</body>
</html>


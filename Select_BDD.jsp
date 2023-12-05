<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>Ajouter un nouveau film</title>
</head>
<body>
    <h1>Ajouter un nouveau film</h1>

    <% 
        String url = "jdbc:mariadb://localhost:3306/films";
        String user = "mysql";
        String password = "mysql";

        // Charger le pilote JDBC
        Class.forName("org.mariadb.jdbc.Driver");

        // Vérifier si des données ont été envoyées pour l'ajout d'un nouveau film
        if (request.getParameter("idFilm") != null && request.getParameter("titre") != null && request.getParameter("annee") != null) {
            int idFilm = Integer.parseInt(request.getParameter("idFilm"));
            String nouveauTitre = request.getParameter("titre");
            int nouvelleAnnee = Integer.parseInt(request.getParameter("annee"));

            try (Connection conn = DriverManager.getConnection(url, user, password)) {
                // Vérifier si l'ID est déjà utilisé
                String checkIdQuery = "SELECT idFilm FROM Film WHERE idFilm = ?";
                try (PreparedStatement checkIdStmt = conn.prepareStatement(checkIdQuery)) {
                    checkIdStmt.setInt(1, idFilm);
                    ResultSet existingId = checkIdStmt.executeQuery();

                    if (existingId.next()) {
    %>
                        <!-- Afficher un message d'erreur si l'ID est déjà utilisé -->
                        <p>L'ID "<%= idFilm %>" est déjà utilisé pour un autre film.</p>
    <%
                    } else {
                        // Requête SQL pour ajouter un nouveau film dans la base de données
                        String insertQuery = "INSERT INTO Film (idFilm, titre, année, genre) VALUES (?, ?, ?, 'Non spécifié')";
                        try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                            insertStmt.setInt(1, idFilm);
                            insertStmt.setString(2, nouveauTitre);
                            insertStmt.setInt(3, nouvelleAnnee);

                            int rowsAffected = insertStmt.executeUpdate();

                            if (rowsAffected > 0) {
    %>
                                <!-- Afficher un message si l'ajout du film a été effectué -->
                                <p>Le film "<%= nouveauTitre %>" de l'année <%= nouvelleAnnee %> avec l'ID <%= idFilm %> a été ajouté avec succès !</p>
    <%
                            } else {
    %>
                                <!-- Afficher un message si l'ajout du film a échoué -->
                                <p>L'ajout du film "<%= nouveauTitre %>" de l'année <%= nouvelleAnnee %> avec l'ID <%= idFilm %> a échoué.</p>
    <%
                            }
                        }
                    }
                }
            } catch (Exception e) {
                // Gérer les exceptions
                e.printStackTrace();
                out.println("Erreur : " + e.getMessage());
            }
        }
    %>

    <!-- Formulaire pour saisir un nouveau film -->
    <form method="post" action="">
        <label for="idFilm">ID du film :</label>
        <input type="number" id="idFilm" name="idFilm">
        <label for="titre">Titre du film :</label>
        <input type="text" id="titre" name="titre">
        <label for="annee">Année :</label>
        <input type="number" id="annee" name="annee" min="1900" max="2100">
        <input type="submit" value="Ajouter">
    </form>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Modification du Titre d'un Film</title>
</head>
<body>
    <h1>Modification du Titre d'un Film</h1>

    <!-- Formulaire pour saisir l'ID et le nouveau titre -->
    <form method="post" action="">
        <label for="filmId">ID du Film :</label>
        <input type="number" id="filmId" name="filmId" required>
        <br>
        <label for="nouveauTitre">Nouveau Titre :</label>
        <input type="text" id="nouveauTitre" name="nouveauTitre" required>
        <br>
        <input type="submit" value="Modifier Titre">
    </form>

    <% 
        try {
            String url = "jdbc:mariadb://localhost:3306/films";
            String user = "mysql";
            String password = "mysql";

            // Vérification de la présence des paramètres dans la requête POST
            if (request.getMethod().equals("POST")) {
                int filmId = Integer.parseInt(request.getParameter("filmId"));
                String nouveauTitre = request.getParameter("nouveauTitre");

                // Charger le pilote JDBC
                Class.forName("com.mysql.jdbc.Driver");

                // Établir la connexion
                try (Connection conn = DriverManager.getConnection(url, user, password)) {
                    // Requête SQL pour mettre à jour le titre du film en fonction de l'ID
                    String sql = "UPDATE Film SET titre = ? WHERE idFilm = ?";
                    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                        pstmt.setString(1, nouveauTitre);
                        pstmt.setInt(2, filmId);

                        // Exécution de la mise à jour
                        int rowsAffected = pstmt.executeUpdate();

                        if (rowsAffected > 0) {
                            out.println("Le titre du film a été modifié avec succès.");
                        } else {
                            out.println("Aucun film trouvé avec l'ID spécifié.");
                        }
                    }
                }
            }
        } catch (Exception e) {
            // Gérer les exceptions (journalisation, affichage d'un message d'erreur, etc.)
            e.printStackTrace();
            out.println("Erreur : " + e.getMessage());
        }
    %>
</body>
</html>

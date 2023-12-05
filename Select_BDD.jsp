<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Connexion à MySQL via JSP</title>
</head>
<body>
    <h1>Exemple de connexion à MySQL via JSP</h1>

    <% 
        try {
            String url = "jdbc:mysql://localhost:3306/films";
            String user = "root";
            String password = "root";

            // Charger le pilote JDBC
            Class.forName("com.mysql.jdbc.Driver");

            // Établir la connexion
            try (Connection conn = DriverManager.getConnection(url, user, password)) {
                // Exemple de requête SQL
                String sql = "SELECT idFilm, titre, année FROM Film WHERE année >= 2000";
                try (PreparedStatement pstmt = conn.prepareStatement(sql);
                     ResultSet rs = pstmt.executeQuery()) {

                    // Afficher les résultats (à adapter selon vos besoins)
                    while (rs.next()) {
                        String colonne1 = rs.getString("idFilm");
                        String colonne2 = rs.getString("titre");
                        String colonne3 = rs.getString("Année");
            %>
                        <!-- Exemple d'affichage de 3 colonnes -->
                        <p>Colonne 1 : <%= colonne1 %>, Colonne 2 : <%= colonne2 %>, Colonne 3 : <%= colonne3 %></p>
            <%
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

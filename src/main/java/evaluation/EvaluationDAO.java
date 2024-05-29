package evaluation;

import util.DatabaseUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class EvaluationDAO {

    public List<EvaluationDTO> getList(String lectureDivide, String searchType, String search, int pageNumber) {
        if (lectureDivide.equals("전체")) {
            lectureDivide = "";
        }
        String SQL = "";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<EvaluationDTO> list = new ArrayList<>();
        try {
            if (searchType.equals("최신순")) {
                SQL = "SELECT * FROM evaluation WHERE lectureDivide LIKE ? AND (lectureName LIKE ? OR professorName LIKE ? OR evaluationTitle LIKE ? OR evaluationContent LIKE ?) ORDER BY 1 DESC LIMIT " + pageNumber * 5 + ", " + (pageNumber * 5 + 6);
            } else if (searchType.equals("추천순")) {
                SQL = "SELECT * FROM evaluation WHERE lectureDivide LIKE ? AND (lectureName LIKE ? OR professorName LIKE ? OR evaluationTitle LIKE ? OR evaluationContent LIKE ?) ORDER BY 14 DESC LIMIT " + pageNumber * 5 + ", " + (pageNumber * 5 + 6);
            }
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, "%" + lectureDivide + "%");
            pstmt.setString(2, "%" + search + "%");
            pstmt.setString(3, "%" + search + "%");
            pstmt.setString(4, "%" + search + "%");
            pstmt.setString(5, "%" + search + "%");
            rs = pstmt.executeQuery();

            while (rs.next()) {
                EvaluationDTO evaluationDTO = new EvaluationDTO();
                evaluationDTO.setEvaluationID(rs.getInt(1));
                evaluationDTO.setUserID(rs.getString(2));
                evaluationDTO.setLectureName(rs.getString(3));
                evaluationDTO.setProfessorName(rs.getString(4));
                evaluationDTO.setLectureYear(rs.getInt(5));
                evaluationDTO.setSemesterDivide(rs.getString(6));
                evaluationDTO.setLectureDivide(rs.getString(7));
                evaluationDTO.setEvaluationTitle(rs.getString(8));
                evaluationDTO.setEvaluationContent(rs.getString(9));
                evaluationDTO.setTotalScore(rs.getString(10));
                evaluationDTO.setGradeScore(rs.getString(11));
                evaluationDTO.setAssignmentScore(rs.getString(12));
                evaluationDTO.setLectureScore(rs.getString(12));
                evaluationDTO.setLikeCount(rs.getInt(14));
                list.add(evaluationDTO);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if (pstmt != null) pstmt.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if (rs != null) rs.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return list;
    }

    public int write(EvaluationDTO evaluationDTO) {
        String SQL = "INSERT INTO evaluation VALUES (null, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, evaluationDTO.getUserID());
            pstmt.setString(2, evaluationDTO.getLectureName());
            pstmt.setString(3, evaluationDTO.getProfessorName());
            pstmt.setInt(4, evaluationDTO.getLectureYear());
            pstmt.setString(5, evaluationDTO.getSemesterDivide());
            pstmt.setString(6, evaluationDTO.getLectureDivide());
            pstmt.setString(7, evaluationDTO.getEvaluationTitle());
            pstmt.setString(8, evaluationDTO.getEvaluationContent());
            pstmt.setString(9, evaluationDTO.getTotalScore());
            pstmt.setString(10, evaluationDTO.getGradeScore());
            pstmt.setString(11, evaluationDTO.getAssignmentScore());
            pstmt.setString(12, evaluationDTO.getLectureScore());
            pstmt.setInt(13, 0);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if (pstmt != null) pstmt.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if (rs != null) rs.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return -1;
    }

    public int delete(String evaluationID) {
        String SQL = "DELETE FROM evaluation WHERE evaluationID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, Integer.parseInt(evaluationID));
            pstmt.executeUpdate();
            return 1;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if (pstmt != null) pstmt.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if (rs != null) rs.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return -1;
    }

    public String getUserID(String evaluationID) {
        String SQL = "SELECT userID FROM evaluation WHERE evaluationID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseUtil.getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, Integer.parseInt(evaluationID));
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getString(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if (pstmt != null) pstmt.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            try {
                if (rs != null) rs.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return null;
    }
}

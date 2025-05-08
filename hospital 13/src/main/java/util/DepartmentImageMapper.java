package util;

import java.util.HashMap;
import java.util.Map;

/**
 * Utility class to map department names to appropriate image URLs
 */
public class DepartmentImageMapper {
    
    private static final Map<String, String> departmentImageMap = new HashMap<>();
    
    static {
        // Initialize with default department images
        // These are common hospital departments with appropriate image paths
        departmentImageMap.put("cardiology", "/images/departments/cardiology.jpg");
        departmentImageMap.put("neurology", "/images/departments/neurology.jpg");
        departmentImageMap.put("orthopedics", "/images/departments/orthopedics.jpg");
        departmentImageMap.put("pediatrics", "/images/departments/pediatrics.jpg");
        departmentImageMap.put("oncology", "/images/departments/oncology.jpg");
        departmentImageMap.put("radiology", "/images/departments/radiology.jpg");
        departmentImageMap.put("emergency", "/images/departments/emergency.jpg");
        departmentImageMap.put("surgery", "/images/departments/surgery.jpg");
        departmentImageMap.put("gynecology", "/images/departments/gynecology.jpg");
        departmentImageMap.put("dermatology", "/images/departments/dermatology.jpg");
        departmentImageMap.put("ophthalmology", "/images/departments/ophthalmology.jpg");
        departmentImageMap.put("ent", "/images/departments/ent.jpg");
        departmentImageMap.put("psychiatry", "/images/departments/psychiatry.jpg");
        departmentImageMap.put("urology", "/images/departments/urology.jpg");
        departmentImageMap.put("gastroenterology", "/images/departments/gastroenterology.jpg");
        departmentImageMap.put("endocrinology", "/images/departments/endocrinology.jpg");
        departmentImageMap.put("nephrology", "/images/departments/nephrology.jpg");
        departmentImageMap.put("pulmonology", "/images/departments/pulmonology.jpg");
        departmentImageMap.put("rheumatology", "/images/departments/rheumatology.jpg");
        departmentImageMap.put("hematology", "/images/departments/hematology.jpg");
        departmentImageMap.put("infectious disease", "/images/departments/infectious-disease.jpg");
        departmentImageMap.put("pathology", "/images/departments/pathology.jpg");
        departmentImageMap.put("anesthesiology", "/images/departments/anesthesiology.jpg");
        departmentImageMap.put("dental", "/images/departments/dental.jpg");
        departmentImageMap.put("pharmacy", "/images/departments/pharmacy.jpg");
        departmentImageMap.put("physical therapy", "/images/departments/physical-therapy.jpg");
        departmentImageMap.put("nutrition", "/images/departments/nutrition.jpg");
        departmentImageMap.put("laboratory", "/images/departments/laboratory.jpg");
        departmentImageMap.put("intensive care", "/images/departments/intensive-care.jpg");
        departmentImageMap.put("neonatal", "/images/departments/neonatal.jpg");
    }
    
    /**
     * Get the appropriate image URL for a department
     * 
     * @param departmentName The name of the department
     * @return The image URL for the department, or a default image if not found
     */
    public static String getImageUrl(String departmentName) {
        if (departmentName == null || departmentName.trim().isEmpty()) {
            return "/images/departments/default-department.jpg";
        }
        
        // Convert to lowercase for case-insensitive matching
        String normalizedName = departmentName.toLowerCase().trim();
        
        // Check for exact match
        if (departmentImageMap.containsKey(normalizedName)) {
            return departmentImageMap.get(normalizedName);
        }
        
        // Check for partial match
        for (Map.Entry<String, String> entry : departmentImageMap.entrySet()) {
            if (normalizedName.contains(entry.getKey()) || entry.getKey().contains(normalizedName)) {
                return entry.getValue();
            }
        }
        
        // Return default image if no match found
        return "/images/departments/default-department.jpg";
    }
}

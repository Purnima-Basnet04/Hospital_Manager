package util;

/**
 * Demonstration class for the PasswordHasher utility.
 * This class shows how to use the PasswordHasher to hash and verify passwords.
 */
public class PasswordHasherDemo {

    public static void main(String[] args) {
        // Example password
        String password = "MySecurePassword123!";
        
        // Hash the password
        System.out.println("Hashing password: " + password);
        String hashedPassword = PasswordHasher.hashPassword(password);
        System.out.println("Hashed password: " + hashedPassword);
        
        // Verify the password
        boolean isValid = PasswordHasher.verifyPassword(password, hashedPassword);
        System.out.println("Password verification result: " + isValid);
        
        // Try with an incorrect password
        String wrongPassword = "WrongPassword123!";
        boolean isInvalid = PasswordHasher.verifyPassword(wrongPassword, hashedPassword);
        System.out.println("Wrong password verification result: " + isInvalid);
        
        // Demonstrate backward compatibility with plain text passwords
        String plainTextPassword = "admin123";
        boolean legacyVerification = PasswordHasher.verifyPassword(plainTextPassword, plainTextPassword);
        System.out.println("Legacy plain text verification result: " + legacyVerification);
    }
}

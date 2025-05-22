package util;

import java.security.SecureRandom;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;

/**
 * Utility class for securely hashing and verifying passwords.
 * This implementation uses PBKDF2 with HMAC-SHA256, which is a modern and secure algorithm
 * recommended by NIST for password hashing.
 */
public class PasswordHasher {

    // Constants for hashing
    private static final int SALT_LENGTH = 16; // 16 bytes = 128 bits
    private static final int HASH_LENGTH = 32; // 32 bytes = 256 bits
    private static final int ITERATIONS = 65536; // Number of hash iterations (NIST recommends at least 10,000)
    private static final String ALGORITHM = "PBKDF2WithHmacSHA256";
    private static final String HASH_SECTIONS_DELIMITER = "$";
    private static final SecureRandom RANDOM = new SecureRandom();

    /**
     * Hashes a password using PBKDF2 with HMAC-SHA256.
     *
     * @param password The password to hash
     * @return A string containing the hashed password with salt and iterations info
     */
    public static String hashPassword(String password) {
        if (password == null || password.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }

        try {
            // Generate a random salt
            byte[] salt = new byte[SALT_LENGTH];
            RANDOM.nextBytes(salt);

            // Hash the password
            PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, ITERATIONS, HASH_LENGTH * 8);
            SecretKeyFactory skf = SecretKeyFactory.getInstance(ALGORITHM);
            byte[] hash = skf.generateSecret(spec).getEncoded();

            // Format: algorithm$iterations$salt$hash
            return ALGORITHM +
                   HASH_SECTIONS_DELIMITER +
                   ITERATIONS +
                   HASH_SECTIONS_DELIMITER +
                   Base64.getEncoder().encodeToString(salt) +
                   HASH_SECTIONS_DELIMITER +
                   Base64.getEncoder().encodeToString(hash);

        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new RuntimeException("Error hashing password: " + e.getMessage(), e);
        }
    }

    /**
     * Verifies a password against a stored hash.
     *
     * @param password The password to verify
     * @param storedHash The stored hash to verify against
     * @return true if the password matches the hash, false otherwise
     */
    public static boolean verifyPassword(String password, String storedHash) {
        if (password == null || password.isEmpty()) {
            return false;
        }

        if (storedHash == null || storedHash.isEmpty()) {
            return false;
        }

        // Handle legacy plain text passwords (for backward compatibility)
        if (!storedHash.contains(HASH_SECTIONS_DELIMITER)) {
            return password.equals(storedHash);
        }

        // Split the stored hash into its components
        String[] parts = storedHash.split("\\" + HASH_SECTIONS_DELIMITER);
        if (parts.length != 4) {
            // Invalid hash format
            return false;
        }

        try {
            String algorithm = parts[0];
            int iterations = Integer.parseInt(parts[1]);
            byte[] salt = Base64.getDecoder().decode(parts[2]);
            byte[] hash = Base64.getDecoder().decode(parts[3]);

            // Hash the input password with the same salt and iterations
            PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterations, hash.length * 8);
            SecretKeyFactory skf = SecretKeyFactory.getInstance(algorithm);
            byte[] testHash = skf.generateSecret(spec).getEncoded();

            // Compare the hashes using a constant-time comparison
            return constantTimeEquals(hash, testHash);

        } catch (Exception e) {
            // If any error occurs during verification, return false
            return false;
        }
    }

    /**
     * Constant-time comparison of two byte arrays to prevent timing attacks.
     *
     * @param a First byte array
     * @param b Second byte array
     * @return true if the arrays are equal, false otherwise
     */
    private static boolean constantTimeEquals(byte[] a, byte[] b) {
        if (a.length != b.length) {
            return false;
        }

        int result = 0;
        for (int i = 0; i < a.length; i++) {
            result |= a[i] ^ b[i]; // XOR will be 0 for matching bytes, non-zero for different bytes
        }

        return result == 0;
    }
}

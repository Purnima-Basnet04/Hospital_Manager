-- Create the doctor_departments table if it doesn't exist
CREATE TABLE IF NOT EXISTS doctor_departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    department_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (doctor_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
    UNIQUE KEY unique_doctor_department (doctor_id)
);

-- Add index for faster lookups
CREATE INDEX IF NOT EXISTS idx_doctor_departments_doctor_id ON doctor_departments(doctor_id);
CREATE INDEX IF NOT EXISTS idx_doctor_departments_department_id ON doctor_departments(department_id);

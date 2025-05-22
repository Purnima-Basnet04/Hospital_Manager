package model;

import java.util.Date;

public class Bill {
    private int id;
    private int patientId;
    private String description;
    private double amount;
    private String status;
    private Date billingDate;
    private Date dueDate;
    private Date paymentDate;
    
    // Constructors
    public Bill() {
    }
    
    public Bill(int id, int patientId, String description, double amount, String status, 
                Date billingDate, Date dueDate, Date paymentDate) {
        this.id = id;
        this.patientId = patientId;
        this.description = description;
        this.amount = amount;
        this.status = status;
        this.billingDate = billingDate;
        this.dueDate = dueDate;
        this.paymentDate = paymentDate;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getPatientId() {
        return patientId;
    }
    
    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public double getAmount() {
        return amount;
    }
    
    public void setAmount(double amount) {
        this.amount = amount;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Date getBillingDate() {
        return billingDate;
    }
    
    public void setBillingDate(Date billingDate) {
        this.billingDate = billingDate;
    }
    
    public Date getDueDate() {
        return dueDate;
    }
    
    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }
    
    public Date getPaymentDate() {
        return paymentDate;
    }
    
    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }
}

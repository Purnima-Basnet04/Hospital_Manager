package model;

public class Department {
    private int id;
    private String name;
    private String description;
    private String imageUrl;
    private String building;
    private int floor;
    private int specialistsCount;
    
    // Constructors
    public Department() {}
    
    public Department(int id, String name, String description, String imageUrl, 
                      String building, int floor, int specialistsCount) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.imageUrl = imageUrl;
        this.building = building;
        this.floor = floor;
        this.specialistsCount = specialistsCount;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public String getBuilding() {
        return building;
    }
    
    public void setBuilding(String building) {
        this.building = building;
    }
    
    public int getFloor() {
        return floor;
    }
    
    public void setFloor(int floor) {
        this.floor = floor;
    }
    
    public int getSpecialistsCount() {
        return specialistsCount;
    }
    
    public void setSpecialistsCount(int specialistsCount) {
        this.specialistsCount = specialistsCount;
    }
}
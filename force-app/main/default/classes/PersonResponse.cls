public class PersonResponse {
    
    public class DataAddOns {
        public String id;
        public String name;
        public Boolean enabled;
        public Boolean applied;
        public String description;
        public String docLink;
    }

    public class Details {
        public Name name;
        public Age age;
        public String gender;
        public List<Emails> emails;
        public List<Phones> phones;
        //public Phones profiles;
        public List<Locations> locations;
        public List<Phones> employment;
        public List<Photos> photos;
        public List<Education> education;
        public List<Phones> urls;
        public List<Interests> interests;
        public List<Phones> topics;
    }

    public class Name {
        public String given;
        public String family;
    }
    
    public class Phones {
        
    }
    
    public class Photos {
        public String label;
        public String value;
    }
    
    public class Age {
        public String range;
        public Integer value;
    }
    
    public class Interests {
        public String name;
        public String id;
        public String affinity;
        public String category;
        public List<String> parentIds;
    }
    
    public class Education {
        public String name;
        public String degree;
        public EndEducation endEducation;
        public Object start;        
    }
    
    public class EndEducation {
        public Integer year;
    }
    
    public class Locations {
        public String label;
        public String city;
        public String region;
        public String country;
        public String countryCode;
        public String formatted;
    }

    public class Emails {
        public String label;
        public String value;
    }

    public String email;
    public String emailHash;
    public String phone;
    public String fullName;
    public String ageRange;
    public String gender;
    public String location;
    public String title;
    public String organization;
    public String twitter;
    public String linkedin;
    public String facebook;
    public String bio;
    public String avatar;
    public String website;
    public Details details;
    public List<DataAddOns> dataAddOns;
    public String updated;
    
    public static PersonResponse parse(String json) {
        return (PersonResponse) System.JSON.deserialize(json, PersonResponse.class);
    }

}
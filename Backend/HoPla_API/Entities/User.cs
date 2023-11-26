using System.ComponentModel.DataAnnotations;

namespace HoPla_API.Entities
{
    public class User
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(50)]
        public string Email { get; set; }

        [Required]
        [MaxLength(50)]
        public string Name { get; set; }

        [Required]
        public string Password { get; set; }

        [Required]
        public bool HasPremium { get; set; }

        public House? House { get; set; }

        public User() { }

        public User(string email, string name, string password, bool hasPremium, House house)
        {
            Email = email;
            Name = name;
            Password = password;
            HasPremium = hasPremium;
            House = house;
        }
    }

    public class RegisterModel
    {
        public string Email { get; set; }
        public string Name { get; set; }
        public string Password { get; set; }
    }

    public class LoginModel
    {
        public string Email { get; set; }
        public string Password { get; set; }
    }

    public class UpdateUser
    {
        public string Email { get; set; }
        public string Name { get; set; }
        public bool HasPremium { get; set; }
    }
}

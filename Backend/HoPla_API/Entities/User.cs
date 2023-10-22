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
        [MaxLength(20)]
        public string Password { get; set; }

        [Required]
        public bool HasPremium { get; set; }

        [Required]
        public House House { get; set; }

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
}

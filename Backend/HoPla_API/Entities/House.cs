using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;

namespace HoPla_API.Entities
{
    public class House
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(50)]
        public string Name { get; set; }

        [Required]
        public bool HasPremium { get; set; }

        [Required]
        [AllowNull]
        public ICollection<Item> Items { get; set; }

        public House(string name, bool hasPremium)
        {
            Name = name;
            HasPremium = hasPremium;
        }
    }
}

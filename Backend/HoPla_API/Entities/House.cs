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

        public int? HouseSize { get; set; }

        [AllowNull]
        public ICollection<Item> Items { get; set; }

        public House(string name, bool hasPremium)
        {
            Name = name;
            HasPremium = hasPremium;
            Items = new List<Item>();
        }
    }

    public class HouseInputModel
    {
        [MaxLength(50)]
        public string Name { get; set; }

        public bool HasPremium { get; set; }

        public int? HouseSize { get; set; }
    }
}

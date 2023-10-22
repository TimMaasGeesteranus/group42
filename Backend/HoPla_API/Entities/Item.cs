using System.ComponentModel.DataAnnotations;

namespace HoPla_API.Entities
{
    public class Item
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(50)]
        public string Name { get; set; }

        [Required]
        public House House { get; set; }

        public ICollection<Reservation> Reservations { get; set; }
    }
}

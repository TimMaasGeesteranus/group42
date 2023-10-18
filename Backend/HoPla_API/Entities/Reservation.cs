using System.ComponentModel.DataAnnotations;

namespace HoPla_API.Entities
{
    public class Reservation
    {
        //[Required]
        //public User User { get; set; }

        //[Required]
        //public Item Item { get; set; }

        [Key]
        public int TestId {  get; set; }

        [Required]
        public DateTime StartTime { get; set; }

        [Required]
        public DateTime EndTime { get; set; }
    }
}

namespace RaceDay.API.Models
{
    public class Enrolment
    {
        public int Id { get; set; }
        public DateTime EnrolmentDate { get; set; } = DateTime.UtcNow;

        public int UserId { get; set; }
        public User? User { get; set; }

        public int EventId { get; set; }
        public Event? Event { get; set; }

        public int CategoryId { get; set; }
        public Category? Category { get; set; }
    }
}
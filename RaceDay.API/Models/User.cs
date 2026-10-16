namespace RaceDay.API.Models
{
    public class User
    {
        public int Id { get; set; }
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Role { get; set; } = "Participant"; // Organiser or Participant

        public ICollection<Enrolment> Enrolments { get; set; } = new List<Enrolment>();
    }
}
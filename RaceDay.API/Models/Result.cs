using System.ComponentModel.DataAnnotations;

namespace RaceDay.API.Models
{
    public class Result
    {
        public int Id { get; set; }

        [Required]
        public int EnrolmentId { get; set; }
        public Enrolment? Enrolment { get; set; }

        public TimeSpan FinishTime { get; set; }

        public int Position { get; set; }
    }
}
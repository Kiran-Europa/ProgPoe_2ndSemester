using Microsoft.AspNetCore.Mvc;
using RaceDay.API.Services;

namespace RaceDay.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UploadController : ControllerBase
    {
        private readonly BlobService _blobService;

        public UploadController(BlobService blobService)
        {
            _blobService = blobService;
        }

        // POST: api/upload/image
        [HttpPost("image")]
        public async Task<IActionResult> UploadImage(IFormFile file)
        {
            if (file == null || file.Length == 0)
            {
                return BadRequest("No file uploaded.");
            }

            try
            {
                var fileUrl = await _blobService.UploadFileAsync(file);
                return Ok(new { Url = fileUrl });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
    }
}
using Microsoft.AspNetCore.Mvc;
using MyFit_Backend.Models;

namespace MyFit_Backend.Controllers;

[Route("bmi")]
public class BmiController : ControllerBase
{
    private static readonly List<BmiData> _allBmiData = new();
    
    [HttpGet]
    [Route("/bmi/allData")]
    public virtual IActionResult BmiAllDataGet([FromQuery] string deviceUUID)
    {
        return Ok(_allBmiData.ToArray());
    }

    [HttpPost]
    [Route("/bmi/create")]
    public virtual IActionResult BmiCreatePost([FromQuery] float weight,
        [FromQuery] float height, [FromQuery] string deviceUUID)
    {
        var unixTimeMilliseconds = DateTime.Now.ToUniversalTime().Subtract(
            DateTime.UnixEpoch
        ).TotalMilliseconds;
        
        var bmiData = new BmiData
        {
            Height = height,
            Weight = weight,
            TimeStamp = unixTimeMilliseconds
        };
        
        _allBmiData.Add(bmiData);
        return Ok(weight / Math.Pow(height / 100, 2));
    }

    [HttpDelete]
    [Route("/bmi/delete")]
    public virtual IActionResult LoginUser([FromQuery] double timeStamp,
        [FromQuery] string deviceUUID)
    {
        _allBmiData.Remove(_allBmiData.Single(b => b.TimeStamp == timeStamp));
        return Ok();
    }
}
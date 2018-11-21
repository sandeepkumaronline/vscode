var prev = document.getElementById("prev");
var next = document.getElementById("next");
var image = document.getElementById("image");
var numberInput = document.getElementById("number");
var validationMessage = document.getElementById("validationMessage");

// store image paths in an array
var images = ["https://s3-us-west-2.amazonaws.com/s.cdpn.io/1259621/city.jpg", "https://s3-us-west-2.amazonaws.com/s.cdpn.io/1259621/cloudy.jpg", "https://s3-us-west-2.amazonaws.com/s.cdpn.io/1259621/green.jpg", "https://s3-us-west-2.amazonaws.com/s.cdpn.io/1259621/pretty_clouds.jpg"];

var imageIndex = 0;
// point to previous image when prev button is clicked
prev.onclick = function () {
  // set image to highest index when moving past 0
  if (imageIndex == 0) {
    imageIndex = images.length - 1;
  }
  else {
    imageIndex--;
  }
  image.setAttribute("src", images[imageIndex]);
}
// point to previous image when prev button is clicked
next.onclick = function () {
  // set image index to 0 when moving past max index
  if (imageIndex == images.length - 1) {
    imageIndex = 0;
  }
  else {
    imageIndex++;
  }
  image.setAttribute("src", images[imageIndex]);
}

function verify() {
  if (numberInput.value < 40 || numberInput.value > 90) {
    validationMessage.style.display = "block";
    return false;
  }
  else if (isNaN(numberInput.value)) {
    nanMessage.style.display = "block";
  }
  else {
    validationMessage.style.display = "none";
    return true;
  }
}

numberInput.onchange = function () {
  if (isNaN(numberInput.value)) {
    nanMessage.style.display = "block";
  }
  else {
    nanMessage.style.display = "none";
  }
}
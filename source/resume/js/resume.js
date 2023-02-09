const $topnav = $(".topnav");
const $toc = $topnav.find("#toc");

// hide the nav when clicking outside the nav drawer
$(document.body).click(() => $toc.hide());
$topnav.click((event) => event.stopPropagation());

// hamburger menu
$(".icon").click(() => $toc.toggle());

$(() => {
  Toc.init({
    $nav: $toc,
    $scope: $("h2"),
  });

  const $navLinks = $toc.find("a");
  $navLinks.click(() => $toc.hide());
});

const $toc = $("#toc");
$(".icon").click(() => $toc.toggle());

$(() => {
  Toc.init({
    $nav: $toc,
    $scope: $("h2"),
  });

  const $navLinks = $toc.find("a");
  $navLinks.click(() => $toc.hide());
});

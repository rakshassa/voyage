document.addEventListener("turbolinks:load", function() {

  $(function() {
    $('a#show_completed_quests').click(function(event){
      event.preventDefault();
      $('div#completed_quests').toggle();
    });
  });

});

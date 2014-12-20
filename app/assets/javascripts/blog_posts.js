$(document).ready(function() {
  var tagLabels = $('#tag-labels').data('tags');
  var tags = $('#tags-data').data('tags');

  $('#blog-post-tags').tagit({
    availableTags: tagLabels,
    autocomplete: { delay: 0, minLength: 1 },
    beforeTagAdded: function(event, ui) {
      // Use callback to return false, if ui.tagLabel
      // is not inside the availableTags array.
      if(tagLabels.indexOf(ui.tagLabel) === -1) {
        return false;
      }
    }
  });

  // Catch submit so that we can match the tag
  // names chosen via the tagit plugin to their
  // corresponding tag ids to send to backend.
  $('form').submit(function() {
    var tagLabelsArr = $("#blog-post-tags").val().split(',');
    var tagIds = [];

    for(var i = 0;i < tags.length;i++) {
      if (tagLabelsArr.indexOf(tags[i].name) !== -1) {
        tagIds.push({ tag_id: tags[i].id });
      }
    }

    $('#tags-hidden').val(JSON.stringify(tagIds));
  });
});

$(document).on('turbolinks:load', function() {
  const replyLinks  = document.querySelectorAll('.reply-link a');
  const cancelLinks = document.querySelectorAll('.cancel-link a');
  const replyCount  = replyLinks.length;
  const cancelCount = cancelLinks.length;

  if(replyCount == 0) return;

  for(var i; i<replyCount; i++){ replyLinks[i].addEventListener('click', showReplyForm)};

  if(cancelCount == 0) return;

  for(var i; i<cancelCount; i++){ cancelLinks[i].addEventListener('click', showReplyForm)};
});

function showReplyForm(e) {
  e.preventDefault();

  const commentID  = e.target.dataset.commentId;
  const replyForm  = document.querySelector('#reply_form_for_comment_'  + commentID);
  const replyLink  = this
  const cancelLink = document.querySelector('#cancel_link_for_comment_' + commentID);

  replyForm.style.display  = 'block'
  replyLink.style.display  = 'none'
  cancelLink.style.display = 'block'
}

function hideReplyForm(e) {
  e.preventDefault();

  const commentID  = e.target.dataset.commentId;
  const replyForm  = document.querySelector('#reply_form_for_comment_'  + commentID);
  const replyLink  = document.querySelector('#reply_link_for_comment_' + commentID);
  const cancelLink = this

  resetFormWithImages(replyForm.querySelector('form'));

  replyForm.style.display  = 'none'
  replyLink.style.display  = 'block'
  cancelLink.style.display = 'none'
}

function resetFormWithImages(form){
  const fileLabel  = form.querySelector('.file-input label');
  const imagesDiv  = form.querySelector('.attached-images');

  imagesDiv.innerHTML='';
  fileLabel.innerText = 'No file chosen';
  form.reset();
}

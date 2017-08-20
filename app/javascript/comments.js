$(document).on('turbolinks:load', function() {
	document.querySelectorAll('.reply-link a').forEach(a => a.addEventListener('click', showReplyForm));
	document.querySelectorAll('.cancel-link a').forEach(a => a.addEventListener('click', hideReplyForm));
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
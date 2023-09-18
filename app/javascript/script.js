/* sign upバリデーション

document.addEventListener('DOMContentLoaded', function() {
  const accountValidation = /^[a-zA-Z0-9]{3,25}$/;
  const emailValidation = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/;
  const passwordValidation = /.{6,}/;
  const nicknameValidation = /^[a-zA-Z0-9]{3,25}$/;

  function checkInput(inputId, validationRegex) {
    const input = document.getElementById(`user_${inputId}`);
    const validationMessage = document.getElementById(`${inputId}-validation`);
    const inputValue = input.value;

    const validationTexts = validationMessage.querySelectorAll('.validation-text');
    
    // 初期化
    validationTexts.forEach(text => {
      text.classList.remove('valid', 'invalid');
      text.style.display = 'none'; // 最初は非表示に
    });

    if (inputValue.length > 0) {
      if (validationRegex.test(inputValue)) {
        // 合格の場合
        validationTexts.forEach(text => {
          text.classList.add('valid');
          text.style.display = 'block'; // 入力がある場合のみ表示
        });
      } else {
        // 不合格の場合
        validationTexts.forEach(text => {
          text.classList.add('invalid');
          text.style.display = 'block'; // 入力がある場合のみ表示
        });
      }
    }
  }

  const accountInput = document.getElementById('account');
  if (accountInput) {
    accountInput.addEventListener('input', () => checkInput('account', accountValidation));
  }

  const emailInput = document.getElementById('email');
  if (emailInput) {
    emailInput.addEventListener('input', () => checkInput('email', emailValidation));
  }

  const passwordInput = document.getElementById('password');
  if (passwordInput) {
    passwordInput.addEventListener('input', () => checkInput('password', passwordValidation));
  }

  const passwordConfirmationInput = document.getElementById('password_confirmation');
  if (passwordConfirmationInput) {
    passwordConfirmationInput.addEventListener('input', () => checkInput('password_confirmation', passwordValidation));
  }

  const nicknameInput = document.getElementById('nickname');
  if (nicknameInput) {
    nicknameInput.addEventListener('input', () => checkInput('nickname', nicknameValidation));
  }
});
*/

//mypageドロップダウンメニュー

document.addEventListener('turbolinks:load', function() {

  const mypageBtnContainer = document.getElementById('mypageBtnContainer');
  const mypageDropdown = document.getElementById('mypageDropdown');

  function toggleDropdown() {
    $(mypageDropdown).slideToggle(300);
  }

  function closeDropdown() {
    $(mypageDropdown).slideUp(300);
  }

  if (mypageBtnContainer) {
    // マイページボタンをクリックしたときにドロップダウンメニューの切り替え
    mypageBtnContainer.addEventListener('click', toggleDropdown);

    // ドロップダウンメニュー内部のクリックイベントをキャンセル
    mypageDropdown.addEventListener('click', function(event) {
      event.stopPropagation();
    });

    // ドロップダウンメニューの外側をクリックしたらドロップダウンを閉じる
    document.addEventListener('click', function(event) {
      if (!mypageBtnContainer.contains(event.target)) {
        closeDropdown();
      }
    });

    // ページ遷移前にドロップダウンメニューを閉じる
    document.addEventListener('turbolinks:before-visit', closeDropdown);
  }
});

document.addEventListener('turbolinks:load', function() {

  const menuBtn = document.getElementById('menuBtn');
  const navDropdown = document.getElementById('navDropdown');

  function toggleDropdown() {
    $(navDropdown).slideToggle(300);
  }

  function closeDropdown() {
    $(navDropdown).slideUp(300);
  }

  if (menuBtn) {
    // Menuボタンをクリックしたときにドロップダウンメニューの切り替え
    menuBtn.addEventListener('click', toggleDropdown);

    // ドロップダウンメニュー内部のクリックイベントをキャンセル
    navDropdown.addEventListener('click', function(event) {
      event.stopPropagation();
    });

    // ドロップダウンメニューの外側をクリックしたらドロップダウンを閉じる
    document.addEventListener('click', function(event) {
      if (!navBtnContainer.contains(event.target)) {
        closeDropdown();
      }
    });

    // ページ遷移前にドロップダウンメニューを閉じる
    document.addEventListener('turbolinks:before-visit', closeDropdown);
  }
});

// コメント編集発火 //
$(document).on("turbolinks:load", () => {
  $("body").on("click", ".js-edit-comment-button",(e) => {
    const commentId = $(e.target).parent().data('commentId');                   
    const commentLabelArea = $('#js-comment-label-' + commentId);  
    const commentTextArea = $('#js-textarea-comment-' + commentId); 
    const commentButton = $('#js-comment-button-' + commentId);   
    
    commentLabelArea.hide();
    commentTextArea.show(); 
    commentButton.show(); 
  });

  $("body").on("click", ".comment-cancel-button", (e) => {
    const commentId = $(e.target).data('cancel-id');
    const commentLabelArea = $('#js-comment-label-' + commentId);
    const commentTextArea = $('#js-textarea-comment-' + commentId);
    const commentButton = $('#js-comment-button-' + commentId);
    const commentError = $('#js-comment-post-error-' + commentId);

    commentLabelArea.show();
    commentTextArea.hide();
    commentButton.hide();
    commentError.hide();
  });
})

$(document).ready(function() {
  // スクロールトップボタンをクリックしたときの処理
  $('.scroll-top-btn').click(function(e) {
    e.preventDefault(); // リンクのデフォルトの動作を無効化
    $('html, body').animate({ scrollTop: 0 }, 'slow'); // ページトップへスクロール
  });

  // ページが一定のスクロール量までスクロールされたらボタンを表示
  $(window).scroll(function() {
    if ($(this).scrollTop() > 100) {
      $('.scroll-top-btn').fadeIn();
    } else {
      $('.scroll-top-btn').fadeOut();
    }
  });
});



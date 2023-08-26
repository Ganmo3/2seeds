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


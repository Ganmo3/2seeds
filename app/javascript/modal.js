// notification
// ターボリンクの読み込みイベントに対応
document.addEventListener('turbolinks:load', function() {
  // notification
  $('#notifications-link').click(function() {
    // 通知を確認済みに更新するアクションを呼び出す
    $.ajax({
      url: '<%= update_checked_notifications_path %>',
      type: 'POST',
      success: function() {
        $('.n-circle').removeClass('orange');
        $('#notifications-link').html('<i class="far fa-bell fa-lg" style="font-size: 1.5em;"></i>');

        // 通知モーダルを表示する処理
        $.ajax({
          url: '<%= notifications_path(@user) %>',
          type: 'GET',
          success: function(response) {
            $('#notifications-modal .modal-content').html(response);
            $('#notifications-modal').addClass('fade-in').show();
          }
        });
      }
    });
  });

  $('#notifications-modal').on('click', function() {
    $(this).addClass('fade-out');
    setTimeout(() => {
      $(this).hide().removeClass('fade-out');
    }, 300);
  });
});





// report
$(document).ready(function() {
  $('.open-report-modal-button').click(function() {
    const commentId = $(this).data("comment-id");
    
    $.ajax({
      url: '<%= new_report_path %>', // new_report_pathを使用
      type: 'GET',
      data: { content_id: commentId, content_type: "Comment" },
      success: function(response) {
        $('#report-modal .modal-content').html(response);
        $('#report-modal').addClass('fade-in').show();
      }
    });
  });

  $('#report-modal').on('click', function(event) {
    if (event.target === this) {
      $(this).addClass('fade-out');
      setTimeout(() => {
        $(this).hide().removeClass('fade-out');
      }, 300); // アニメーションの時間に合わせて調整
    }
  });
});


// following
  $(document).ready(function() {
    $('#following-count').click(function() {
      $.ajax({
        url: '<%= following_list_user_path(@user) %>',
        type: 'GET',
        success: function(response) {
          $('#following-modal .modal-content').html(response);
          $('#following-modal').addClass('fade-in').show();
        }
      });
    });

    $('#following-modal').on('click', function(event) {
      if (event.target === this) {
        $(this).addClass('fade-out');
        setTimeout(() => {
          $(this).hide().removeClass('fade-out');
        }, 300); // アニメーションの時間に合わせて調整
      }
    });
  });


// follower
  $(document).ready(function() {
    $('#follower-count').click(function() {
      $.ajax({
        url: '<%= follower_list_user_path(@user) %>',
        type: 'GET',
        success: function(response) {
          $('#follower-modal .modal-content').html(response);
          $('#follower-modal').addClass('fade-in').show();
        }
      });
    });

    $('#follower-modal').on('click', function() {
      $(this).addClass('fade-out');
      setTimeout(() => {
        $(this).hide().removeClass('fade-out');
      }, 300); // アニメーションの時間に合わせて調整
    });
  });

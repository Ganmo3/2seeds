// 相対的時間 //

function formatRelativeTime(date) {
  var now = new Date();
  var diff = Math.floor((now - date) / 1000); // 差を秒単位で計算

  if (diff < 60) {
    return "たった今";
  } else if (diff < 3600) {
    return Math.floor(diff / 60) + "分前";
  } else if (diff < 86400) {
    return Math.floor(diff / 3600) + "時間前";
  } else {
    return Math.floor(diff / 86400) + "日前";
  }
}

document.addEventListener("turbolinks:load", function() {
  var dateElements = document.querySelectorAll("[data-updated-at], [data-created-at]");

  dateElements.forEach(function(element) {
    var updatedAt = new Date(element.getAttribute("data-updated-at"));
    var createdAt = new Date(element.getAttribute("data-created-at"));

    var relativeUpdatedAt = formatRelativeTime(updatedAt);
    var relativeCreatedAt = formatRelativeTime(createdAt);

    if (updatedAt > createdAt) {
      element.textContent = "更新日: " + relativeUpdatedAt;
    } else {
      element.textContent = "作成日: " + relativeCreatedAt;
    }
  });
});
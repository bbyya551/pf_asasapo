/* global $*/
/* global location*/
$(document).on('turbolinks:load', function () {
  // console.log("読み込まれました");
  $(window).on('scroll', function() {
    scrollHeight = $(document).height();
    // scrollTopはscroll量を調べる
    scrollPosition = $(window).height() + $(window).scrollTop();
    if ( (scrollHeight - scrollPosition) / scrollHeight <= 0.05) {
      //スクロールの位置が下部5%の範囲に来た場合
          $('.jscroll').jscroll({
            contentSelector: '.scroll-list',
            // 'a[rel=next]:last'は、htmlのページネーションのclassはどれも同じだった。nextボタンのみ、何か指定してやる必要があり、nextボタンには、rel = nextが指定されていたので、それをNextSelecterとして指定した。
            nextSelector: 'a[rel=next]:last'
          });
    }
  });
});

// $(document).on('turbolinks:load', function () {
//   console.log("読み込まれました");
//   $(window).on('scroll', function() {
//     scrollHeight = $(document).height();
//     // scrollTopはscroll量を調べる
//     scrollPosition = $(window).height() + $(window).scrollTop();
//     if ( (scrollHeight - scrollPosition) / scrollHeight <= 0.05) {
//       //スクロールの位置が下部5%の範囲に来た場合
//           $('.jscroll-g').jscroll({
//             contentSelector: '.scroll-list-g',
//             // 'a[rel=next]:last'は、htmlのページネーションのclassはどれも同じだった。nextボタンのみ、何か指定してやる必要があり、nextボタンには、rel = nextが指定されていたので、それをNextSelecterとして指定した。
//             nextSelector: 'a[rel=next]:last'
//           });
//     }
//   });
// });

// 遷移するとき、差分を読み込んでいるだけなので、この記述(turbolinks:load)がないと動作しない。
$(document).on('turbolinks:load', function () {
  // console.log("location.href");
  // console.log(location.href.match(/chats/));
  // console.log("location.href");
  // (参考にした記事)
  // https://mebee.info/2020/11/23/post-17840/
  // https://uxmilk.jp/9205
  // https://qiita.com/kazu56/items/557740f398e82fc881df
  // if ( str.match(/hoge/)) ⇦ここの例で言うと、str = location.hrefを代入してもいい。
  // location.hrefでurlを取得してきて、その中にchatsが含まれるかと言う意味。
  if (location.href.match(/chats/)) {

    let elm = document.documentElement;
    // scrollHeight ページの高さ clientHeight ブラウザの高さ
    let bottom = elm.scrollHeight - elm.clientHeight;
    // 垂直方向へ移動window.scroll( 数値(水平) , 数値(垂直) ) ;
    window.scroll(0, bottom);
  }
});

// $(document).on('turbolinks:load', function () {
//   $(function(){
//   	//現在のページURLのハッシュ部分を取得
//   	const hash = location.hash;

//   	//ハッシュ部分がある場合の条件分岐
//   	if(hash){
//   		//ページ遷移後のスクロール位置指定
//   		$("html, body").stop().scrollTop(0);
//   		//処理を遅らせる
//   		setTimeout(function(){
//   			//リンク先を取得
//   			const target = $(hash),
//   			//リンク先までの距離を取得
//   			position = target.offset().top;
//   			//指定の場所までスムーススクロール
//   			$("html, body").animate({scrollTop:position}, 500, "swing");
//   		});
//   	}
//   });
// });

// $(document).on('turbolinks:load', function () {
//   if (location.href.match(/posts/)) {
// //     console.log("読み込まれましたposts");
// //     let scrollToOptions = {
// //         top : 0, //スクロール位置にページ最上部を指定
// //         behavior : 'smooth' //スムーズに移動させる条件を指定
// //     };
// //     //スクロールを実施する
// //     window.scrollTo(scrollToOptions);
//       //window.scroll(0, 0);
//       // $(window).scrollTop(0);
//   }
// });

// $(document).on('turbolinks:load', function () {
//   if (location.href.indexOf(/groups/)) {

//     let scrollToOptions = {
//         top : 0, //スクロール位置にページ最上部を指定
//         behavior : 'smooth' //スムーズに移動させる条件を指定
//     };
//     //スクロールを実施する
//     window.scrollTo(scrollToOptions);
//     // window.scroll(0, 0);
//   }
// });

$(document).on('turbolinks:load', function () {
  $('#tab-contents .tab[id != "tab1"]').hide();

  $('#tab-menu a').on('click', function(event) {
    $("#tab-contents .tab").hide();
    $("#tab-menu .active").removeClass("active");
    $(this).addClass("active");
    $($(this).attr("href")).show();
    event.preventDefault();
  });
});

// https://techmemo.biz/javascript/tab-direct-link/(参考にした記事)
$(document).on('turbolinks:load', function() {
  //URL取得とチェック
  if ( location.href.match(/\?tab=tab\d+$/)) {
  // var url = location.href;
  // urlに、tab = tabを含んでいるか確認
  // url = (url.match(/\?tab=tab\d+$/) || [])[0];
  //取得したURLを「?」で分ける。
  // var params = url.split("?");
  var params = location.href.split("?");
  //params内のデータを「=」で分割
  // 分けたurlの、前半が[0]、後半が[1]。後半をさらに"="で分ける。
  var tab = params[1].split("=");

  //tab内のデータをtabnameに格納
  if($(tab).length){
    // urlの最後(tab[1])がtab =2 なら、tabnameは、tab =2
    var tabname = tab[1];
  } else{
    var tabname = "tab1";
  }
  // #tab2のhrefを取得するために変数を定義
  var hrefname = "#" + tabname;

  //コンテンツ非表示&amp;タブを非アクティブ
  $("#tab-contents .tab").hide();
  $("#tab-menu .active").removeClass('active');
  $(hrefname).show();
  // 変数展開のようにして、#tab2のhrefをもつaタグをactiveにするためには、``で囲む
  $(`#tab-menu li a[href='${hrefname}']`).addClass("active");
  event.preventDefault();

  }
});


$(document).on('turbolinks:load', function() {
  $(function () {
    $('.user-edit-btn').hover(function() {
      $(this).next('p').show();
    }, function(){
      $(this).next('p').hide();
    });
  });
});

$(document).on('turbolinks:load', function() {
  $(function () {
    $('.new-group-btn').hover(function() {
      $(this).next('p').show();
    }, function(){
      $(this).next('p').hide();
    });
  });
});

$(document).on('turbolinks:load', function() {
  $(function () {
    $('.new-post-btn').hover(function() {
      $(this).next('p').show();
    }, function(){
      $(this).next('p').hide();
    });
  });
});

$(document).on('turbolinks:load', function() {
  $(function () {
    $('.favorite-post-btn').hover(function() {
      $(this).next('p').show();
    }, function(){
      $(this).next('p').hide();
    });
  });
});




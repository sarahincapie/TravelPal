//= require jquery
//= require d3
//= require c3
//= require jquery_ujs
//= require leaflet
//= require progressbar
//= require_tree .

$('#how-button').click(function(){
    $('body').animate({
        scrollTop: $('#how-div').offset().top
    }, 500);
    return false;
});

$('#tech').click(function(){
    $('body').animate({
        scrollTop: $('#what_we_do_div').offset().top
    }, 500);
    return false;
});


// Roberts Code ^^


function Broadcaster(){
  this.broadcasting = false;
  this.wave = $('.radio-wave');
  this.broadcastingWaves = $('.broadcast');
  this.init();
}

Broadcaster.prototype ={
  broadcast: function(animationDelay, broadcastDelay){
    var self = this;
    if (!this.broadcasting){
      console.log('broadcasting');
      self.wave.addClass('broadcast');
      this.broadcasting = true;
      setTimeout(function(){
        self.wave.addClass('show');
      }, animationDelay);
    }else{
      this.broadcasting = false;
      self.wave.removeClass('broadcast');
    }
  },
  rebroadcast: function(animationDelay, broadcastDelay){
    console.log('rebroadcasting');
    var self = this;
    this.reset();
    this.quietBtn();
    setTimeout(function(){
      self.wave.addClass('broadcast');
      setTimeout(function(){
        self.wave.addClass('show');
        self.activateBtn();
      }, animationDelay);
    }, broadcastDelay);
  },
  reset: function(){
    this.wave.removeClass('broadcast');
    this.wave.removeClass('show');
  },
  quietBtn: function(){
    console.log('off');
    $('.btn-broadcast').off('click');
  },
  activateBtn: function(){
    var self = this;
    $('.btn-broadcast').click(function(){
      self.broadcast(750,0);
    });
  },
  init: function(){
    this.activateBtn();
  }
};
function startChasing(){
  $('.radio-wave').addClass('broadcast');
  $('.robot-message').addClass('show broadcast');
  $('.left-leg').addClass('chase');
  $('.right-arm').addClass('shake');
  $('.left-arm').addClass('shake');
  setTimeout(function(){
    $('.right-leg').addClass('chase');
  }, 750);
  $('.buttons').addClass('hide');
}

function wave(){
  $('.right-arm').addClass('wave');
}


function getClass(btn){
  return btn.attr('class').split(' ')[1].split('-')[1];
}

$(function(){
  var broadcaster = new Broadcaster();

  $(window).scroll(function() {
    var topOfWindow = $(window).scrollTop();
    // console.log(topOfWindow);
    $('.radio-wave').each(function(){
      var imagePos = $(this).offset().top;

      if (imagePos < topOfWindow+400 && !broadcaster.broadcasting) {
        broadcaster.broadcast(1250,0);
      }
    });
  });
  $('.btn-wave').click(function(){
    $('.right-arm').removeClass('wave');
    setTimeout(function(){wave();}, 500);
  });
  $('.btn-chase').click(function(){startChasing();});
});

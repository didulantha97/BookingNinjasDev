$(document).ready(function() {
	//fancybox
	$('.fancybox').fancybox({
		helpers: {
			overlay: {
				locked: false
			}
		}
	});
	//menu
	$('.nav-trigger').click(function(){
		$(this).next().slideToggle('fast');
	});
	$('.navigation-dropdown__click').click(function(){
		$(this).parent().find('.navigation-dropdown').toggleClass('active');
	});
	$(".thumb").fancybox({
		prevEffect	: 'none',
		nextEffect	: 'none',
		afterLoad: function() {
        this.title = this.title + '<a href="' + this.href + '" target="_blank">Download</a> ' ;
   		 },
		helpers	: {
			

			thumbs	: {
				width	: 100,
				height	: 100
			}, 
			buttons	: {}
		}
		
	});

	//form
	$('.landing__hero-form .button').click(function(){
		$(this).parent('.landing__hero-form').addClass('landing__hero-form-success');
	});
	$(".footer-btn-submit").click(function() {
		$.fancybox.open({ src : '#modal-thanks', type : 'inline', });
	});

	//slider
	$('.landing__slider').slick({
		dots: true
	});
	$('.js-slider').slick({
		dots: true,
		arrows: true
	});
	$('.costumer-page__carousel').slick({
		slidesToShow: 2,
		slidesToScroll: 1,
		dots: false,
		centerMode: false,
		focusOnSelect: true,
		infinite: true,
		responsive: [
			{
			  breakpoint: 1024,
			  settings: {
				slidesToShow: 1,
				slidesToScroll: 1,
			  }
			}
		  ]
	});

	$('.feature-spotlight__slider-big').slick({
		slidesToShow: 1,
		slidesToScroll: 1,
		arrows: false,
		fade: true,
		asNavFor: '.feature-spotlight__slider-small'
	});
	$('.feature-spotlight__slider-small').slick({
		slidesToShow: 3,
		slidesToScroll: 1,
		asNavFor: '.feature-spotlight__slider-big',
		dots: false,
		centerMode: false,
		focusOnSelect: true,
		infinite: false,
		
	});

	
	

	//wow
	new WOW().init();

	//menu
	$( ".navigation__button" ).click(function() {
	  $( ".navigation" ).toggleClass( "active");
	  $( this ).find("i").toggleClass( "fa-times");
	  $( ".navigation__overlay" ).toggle( );
	});
	// $( ".navigation__close" ).click(function() {
	//   $( ".navigation" ).removeClass( "active");
	//   $( ".navigation__overlay" ).hide( );
	// });
	$( ".navigation__overlay" ).click(function() {
		$( ".navigation" ).removeClass( "active");
		$( ".navigation__overlay" ).hide( );
	});

	//accordeon
	$( ".faq_head" ).click(function() {
	  $(this).next('.faq_answer').slideToggle( "slow");
	  $(this).toggleClass( "active");
	});
	$( ".landing__accordion-trigger" ).click(function() {
		$(this).next().slideToggle( "slow");
		$(this).toggleClass( "active");
	  });
	  $( ".faq__trigger" ).click(function() {
		$(this).next().slideToggle( "fast");
		$(this).toggleClass( "active");
	  });
	  $( ".pricing-section__accordion-trigger" ).click(function() {
		$(this).prev().slideToggle( "fast");
		$(this).toggleClass( "active");
	  });
	  $( ".pricing-section__pos-trigger" ).click(function() {
		$(".pos-section").slideToggle( "fast");
	  });

	//gallery
	$( ".gallery-content__switch input" ).click(function() {
		$('.gallery-content__tab').toggleClass( "active");
	});

	//floating form
	$( ".floating_form_title" ).click(function() {
	  $('.floating_form').toggleClass( "active");
	});

	//covid
	$( ".covid-more button" ).click(function() {
		$('.covid-hidden').slideDown( );
		$(this).hide( );
	});
	$( ".covid-info__close" ).click(function() {
		$('.covid-info ').fadeOut('fast');
	});

	//myth
	$( ".truth__btn" ).click(function() {
	  $(this).closest('.myth-truth__block').addClass( "active");
	});
	$( ".myth__btn" ).click(function() {
	  $(this).closest('.myth-truth__block').removeClass( "active");
	});

	//tabs
	$('.integration_tabs li a').click(function(event){
        event.preventDefault();
        $('.integration_tabs li a').removeClass('active');
        $(this).addClass('active');
        $('.integration_tab').hide();
        $($(this).attr('href')).show();
    });
     $('.tour__nav a').click(function(event){
        event.preventDefault();
        $('.tour__nav a').removeClass('active');
        $(this).addClass('active');
        $('.tour__item').removeClass('active');
        $($(this).attr('href')).addClass('active');
    });
     $('.customer__nav a').click(function(e){
        event.preventDefault(); 
        $('.customer__nav li').removeClass('active');
        $(this).parent().addClass('active');
        $('.customer-top__text').removeClass('active');
        $($(this).attr('href')).addClass('active');
    });
    $('.tab a').click(function(ev){
        event.preventDefault();
        $('.tab li a').removeClass('active');
        $(this).addClass('active');
        $('.tab-content').hide();
        $($(this).attr('href')).show();
	});
	$('.resource-center__tabs-links a').click(function(event){
		event.preventDefault();
		$('.resource-center__tabs-box .col-lg-4').removeClass('active');
		$('.resource-center__tabs-links a').removeClass('active');
		$(this).addClass('active');
		$(".resource-center__tabs-box .col-lg-4").filter($(this).attr('data-href')).addClass('active'); 
	});
	$('.checkout-payment__tab-links li a').click(function(event){
        event.preventDefault();
        $('.checkout-payment__tab-links li a').removeClass('active');
        $(this).addClass('active');
        $('.checkout-payment__tab').hide();
        $($(this).attr('href')).show();
    });

	//show modal
	$("body").one('mouseleave', function() {
		jQuery('.trial__not-leave-black').addClass('active');
	});
	$( ".trial__not-leave-close" ).click(function() {
	  $('.trial__not-leave').removeClass( "active");
	});
	
	 //scroll anchor
	 $('.integration__nav li a, .totop').on('click',function(){
		$('html,body').animate({scrollTop:$($(this).attr('href')).offset().top-105},800);
		return false;
	});

	//demo lead modal
	$("#demo-lead").submit(function() {
		$.ajax({
			type: "POST",
			url: "", // URL to which the request is sent
			data: $(this).serialize()
		}).done(function() {
			$('.demo-lead-modal__form').toggleClass( "active");
			$('.demo-lead-modal__video').toggleClass( "active");
		});
		return false;
	});

	// International Telephone Input
	if(document.querySelector("#trial-phone")){
		var input = document.querySelector("#trial-phone");
		window.intlTelInput(input, {
			preferredCountries : ["us"],
			separateDialCode : true
			// any initialisation options go here
		});
	}
	// input number arrows
	$('.input-number button').on('click',function(){
		if($(this).hasClass('input-number__plus')){
			this.nextElementSibling.stepUp()
		} else if ($(this).hasClass('input-number__minus')){
			this.previousElementSibling.stepDown()
		}
	});
});


//fixed
$(window).scroll(function() {    
	var scroll = $(window).scrollTop();

	if (scroll >= 100) {
		$(".header-index").addClass("fixed");
	} else {
		$(".header-index").removeClass("fixed");
	}
});
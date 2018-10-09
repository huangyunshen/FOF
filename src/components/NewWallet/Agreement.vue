<template>
  <div class="agreement bb-content h-100">
    <div class="x-header">
      <x-header :left-options="{preventGoBack:true, backText: ''}" @on-click-back="$router.replace({name:'CreateWallet'})"></x-header>
    </div>
    <div class="content bb-content h-100 tl pd-40">
      <section class="wrapper bb-content h-100">
        <p class="strong mb">{{$t('Dear')}}</p>

        <p class="strong mb">{{$t('Thanks')}}</p>

        <section class="terms-area">
          <h2>1.{{$t('First')}}</h2>
          <ul class="strong">
            <li>{{$t('First1')}}</li>
            <li>{{$t('First2')}}</li>
            <li>{{$t('First3')}}</li>
          </ul>
        </section>
        <section class="terms-area">
          <h2>2.{{$t('Second')}}</h2>
          <ul class="strong">
            <li>{{$t('Second1')}}</li>
            <li>
              <p class="strong">{{$t('Second2')}}</p>
              <ul class="strong">
                <li>（1）{{$t('Second3')}}</li>
                <li>（2）{{$t('Second4')}} </li>
              </ul>
            </li>
          </ul>
        </section>
        <section class="terms-area">
          <h2>3.{{$t('Third')}}</h2>
          <ul>
            <li>{{$t('Third1')}}</li>
            <li>{{$t('Third2')}}</li>
            <li>
              <p class="strong">{{$t('Third3')}}</p>
              <ul class="strong">
                <li>（1）{{$t('Third4')}}</li>
                <li>（2）{{$t('Third5')}}</li>
              </ul>
              <p class="strong">{{$t('Third6')}}</p>
              <ul class="strong">
                <li>（1）{{$t('Third7')}}</li>
                <li>（2）{{$t('Third8')}}</li>
              </ul>
            </li>
            <li>{{$t('Third9')}}</li>
          </ul>
        </section>
        <section class="terms-area">
          <h2>4. {{$t('Fourth')}}</h2>
          <ul>
            <li>{{$t('Fourth1')}}</li>
          </ul>
        </section>
        <section class="terms-area">
          <h2>5.{{$t('Fifth')}}</h2>
          <ul class="strong">
            <li>
              {{$t('Fifth1')}}
            </li>
            <li>
              {{$t('Fifth2')}}
            </li>
          </ul>
        </section>
        <section class="terms-area">
        </section>
        <p class="strong last">
          {{$t('Last')}}
        </p>
        <p class="strong right last tr">
          {{$t('FOF')}}
        </p>
      </section>
    </div>
  </div>
</template>

<script>

  export default {
    name: "Agreement",
    data() {
      return {
        pwd: '',
        confirmPwd: '',
        agreement:false,
      }
    }
  }
</script>

<style lang="less" scoped>
  .agreement {
    padding-top: 120px;

    .content {
      .wrapper {
        overflow-y: auto;
        padding: 40px;
        border: 1px solid rgba(222,222,222,1);
        border-radius: 20px;
      }
    }
  }
  p, li {
    line-height: 1.5;
  }
  p, li, .mb, h2, h3, h4, h5 {
    margin-bottom: 20px;
    font-size: @base-font-size;
  }
  .strong {
    font-size: 60px;
  }
  .right {
    text-align: right;
  }
  .square {
    list-style: square;
    margin-left: 1rem;
  }
</style>

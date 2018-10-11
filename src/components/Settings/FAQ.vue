<template>
  <div class="FAQ">
    <div class="x-header">
      <x-header :left-options="{preventGoBack:true, backText: ''}" @on-click-back="$router.replace({name:'Setting'})"></x-header>
    </div>
    <div class="content tl">
      <section class="wrapper bb-content h-100">

        <p class="strong mb">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FAQ</p>

        <section class="terms-area">
          <h2>{{$t('Question')}}</h2>
          <ul class="strong">
            <li>{{$t('Answer')}}</li>
          </ul><br/>
        </section>
        <section class="terms-area">
          <h2>{{$t('Question1')}}</h2>
          <ul class="strong">
            <li>{{$t('Answer1')}}</li>
            <li>
              <p >{{$t('Method')}}</p>
              <ul class="strong">
                <li>1.{{$t('Method1')}}</li>
                <li>2.{{$t('Method2')}} </li>
                <li>3.{{$t('Method3')}} </li>
              </ul><br/>
            </li>
          </ul>
        </section>
        <section class="terms-area">
          <h2>{{$t('Question2')}}</h2>
          <ul>
            <li>{{$t('Answer2')}}</li>
          </ul><br/>
        </section>
        <section class="terms-area">
          <h2>{{$t('Question3')}}</h2>
          <ul>
            <li>
              <p >{{$t('Answer3')}}</p>
              <ul class="strong">
                <li>1.{{$t('Answer3a')}}</li>
                <li>2.{{$t('Answer3b')}} </li>
                <li>3.{{$t('Answer3c')}}</li>
              </ul>
            </li>
          </ul>
        </section>
        <section class="terms-area">
          <h2>{{$t('Question4')}}</h2>
          <ul class="strong">
            <li>
              {{$t('Answer4')}}
            </li>
          </ul>
        </section>
        <section class="terms-area">
        </section>
        <p class="strong right last tr">
          FOFGame.io
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
  .FAQ {
    padding-top: 120px;
    height: 100%;
    box-sizing: border-box;

    .content {
      height: 100%;
      padding: 40px;
      box-sizing: border-box;

      .wrapper {
        overflow-y: auto;
        padding: 40px;
        border: 1px solid #4389F5;
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

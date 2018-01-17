`define count = 10
class xname extends transaction;
  constraint c_size{
    size == XSIZE;
  }
  constraint re{
    rep == XR;
  }
  constraint c_mode{
    mode == XMODE;
  }
  constraint c_admode{
    admode == XAD;
  }
endclass

program(v_if vif);
  xname t_or;
endprogram

parameter SDR_DW = 16;

inout[SDR_DW-1:0] sdr_dq;

wire[SDR_BW-1:0] sdr_den_n;


wire[SDR_DW-1:0] sdr_dout;

assign sdr_dq = (&sdr_den_n == 1'b0) ? sdr_dout : {SDR_DW{1'bz}};

I. Ký hiệu và chữ viết tắt
Tiêu chuẩn này sử dụng các ký hiệu và chữ viết tắt sau:
0x:	Tiền tố của các số được biểu diễn dưới dạng thập lục phân (hex)
:	Trường hữu hạn chỉ có hai phần tử 0, 1, tức là  = {0,1}
:	Trường hữu hạn với đa thức sinh nguyên thủy x8  x5  x3  x  1 trên 
Vn:	Tập hợp xâu có độ dài n-bit
:	Phép toán logic XOR trên xâu bít, nghĩa là nếu A và B là hai xâu cùng độ dài thì AB là xâu bít bao gồm các bít là kết quả phép toán logic XOR của A và B
x || y:	Chuỗi kết quả của việc nối xâu y vào xâu x
{0,l}d:	Xâu gồm d bít nhị phân;
  -   :	Phép phủ định của một xâu;
<r>w:	Dạng biểu diễn w-bit của số nguyên r;
 l :	Kích cỡ khối của mã khối, l ϵ {128,256};
 k :	Độ dài khoá của mã khối, k ϵ {128,192,256,384,512};
R :	Số vòng của mã khối, R ϵ {7,8,9}
w :	Kích cỡ của trạng thái con;
t :	Số lượng các byte trong trạng thái con;
:	Biểu diễn tương ứng trạng thái l-bít, trạng thái con w-bit và một byte trong trạng thái con của phép mã hoá và giải mã của MKV
:	Biểu diễn tương ứng trạng thái 2l-bit, trạng thái con w-bit và một byte trong trạng thái con trong chu trình tạo khóa của MKV
 s :	Biến đổi thay thế từng byte trong trạng thái, còn được gọi là hộp thế
SubCells (invSubCells):	Biến đổi trên trạng thái mã hoá (giải mã), dựa trên biến đổi s trên từng byte;
MixWords (invMixWords):	Biến đổi trên trạng thái mã hoá (giải mã), dựa trên biến đổi tuyến tính trên từng trạng thái con;
XWords:				Biến đổi giữa các trạng thái con;
Fl, (invFl):	Hàm vòng (nghịch đảo của hàm vòng) cho phiên bản có kích thước khối l;
UpdateKSl:	Biến đổi cập nhật trạng thái khoá của chu trình tạo khoá;
P:	Bản rõ l-bit, đầu vào của quá trình mã hoá và đầu ra của quá trình giải mã;
X ← P:	Quy tắc khởi tạo trạng thái X từ các byte bản rõ P;
C:	Bản mã l-bít, đầu vào của quá trình giải mã và đầu ra của quá trình mã hoá;
Kmaster:		Khoá k-bit cho MKV;
K  Kmaster:		Quy tắc khởi tạo trạng thái K từ khoá Kmaster;
SWAP (K0,K1):	Phép biến đổi tráo đổi giá trị của hai trạng thái K0,K1 với nhau;
Ki:	Khoá vòng 2l-bit, được biểu diễn thành hai phần l-bit như sau  trong đó  ϵ Vl;
Kpost:			Khoá xoá trắng l-bít;
MKV-l/k:		Phiên bản mã khối với kích cỡ khối l và độ dài khoá k;

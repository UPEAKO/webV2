package ubd;

public class ImageJson {
	public static final int SUCCESS = 1;
	public static final int FAILURE = 0;
	
	private int success;
	private String message;
	private String url;
	
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public int getSign() {
		return success;
	}
	public void setSign(int sign) {
		this.success = sign;
	}
}
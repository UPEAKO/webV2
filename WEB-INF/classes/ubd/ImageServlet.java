package ubd;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
 
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
 
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.google.gson.*;
 

public class ImageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
     
	private static final String uploadPath = "/home/pi/usb/editor/mk";
 
    
    private static final int MEMORY_THRESHOLD   = 1024 * 1024 * 10; 
    private static final int MAX_FILE_SIZE      = 1024 * 1024 * 40; 
    private static final int MAX_REQUEST_SIZE   = 1024 * 1024 * 50; 
 
    
    protected void doPost(HttpServletRequest request,
        HttpServletResponse response) throws ServletException, IOException {
        
        if (!ServletFileUpload.isMultipartContent(request)) {
            PrintWriter writer = response.getWriter();
            response.setContentType("application/json");
			ImageJson imageJson = new ImageJson();
			imageJson.setSign(ImageJson.FAILURE);
			imageJson.setMessage("fail!");
			imageJson.setUrl("");
			writer.write(new Gson().toJson(imageJson, ImageJson.class));
			writer.flush();
            return;
        }
 
        
        DiskFileItemFactory factory = new DiskFileItemFactory();
        
        factory.setSizeThreshold(MEMORY_THRESHOLD);
        
        factory.setRepository(new File("/home/pi/usb/temp"));
 
        ServletFileUpload upload = new ServletFileUpload(factory);
         
        
        upload.setFileSizeMax(MAX_FILE_SIZE);
         
        
        upload.setSizeMax(MAX_REQUEST_SIZE);

        
        upload.setHeaderEncoding("UTF-8"); 

     
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
 
        try {
            @SuppressWarnings("unchecked")
            List<FileItem> formItems = upload.parseRequest(request);
            if (formItems != null && formItems.size() > 0) {
                for (FileItem item : formItems) {
                    if (!item.isFormField()) {
                        String fileName = new File(item.getName()).getName();
                        String filePath = uploadPath + File.separator + fileName;
                        File storeFile = new File(filePath);
                        item.write(storeFile);
						PrintWriter writer = response.getWriter();
						ImageJson imageJson = new ImageJson();
						imageJson.setSign(ImageJson.SUCCESS);
						imageJson.setMessage("success!");
						imageJson.setUrl("http://" + request.getServerName() + ":" + request.getServerPort() + "/editor/mk/" + fileName);
						writer.write(new Gson().toJson(imageJson, ImageJson.class));
						writer.flush();
						return;
                    }
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
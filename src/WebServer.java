import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;

import java.math.BigInteger;

public class WebServer {

  public static final String ROUTE_PATH = "/f.html";
  public static final String ROUTE_PARAM = "n";
  public static final Integer PORT = 8000;

  public static void main(String[] args) throws Exception {
    HttpServer server = HttpServer.create(new InetSocketAddress(PORT), 0);
    server.createContext(ROUTE_PATH, new FactorizationHandler());
    // Multi thread supporta
    server.setExecutor(java.util.concurrent.Executors.newCachedThreadPool());
    server.start();
    System.out.println("Server running on port: " + PORT);
  }

  public static Map<String, String> getQueryParameters(HttpExchange req) {
    Map<String, String> result = new HashMap<String, String>();
    String query = req.getRequestURI().getQuery();
    if (query == null) return result;
    for (String param : query.split("&")) {
      String pair[] = param.split("=");
      if (pair.length>1) {
        result.put(pair[0], pair[1]);
      }else{
        result.put(pair[0], "");
      }
    }
    return result;
  }

  static class FactorizationHandler implements HttpHandler {
    @Override
    public void handle(HttpExchange req) throws IOException {
      IntFactorization f = new IntFactorization();
      String out = "Invalid Request";
      Map<String,String> queryParams = WebServer.getQueryParameters(req);
      Integer response = 400;
      if (queryParams.containsKey(ROUTE_PARAM)) {
        BigInteger number = new BigInteger(queryParams.get(ROUTE_PARAM));
        ArrayList<BigInteger> factors = f.calcPrimeFactors(number);
        int i = 0;
        out = "The prime factors of " + number + " are:\n";
        for (BigInteger bi: factors) {
          i++;
          out += bi;
          if (i == factors.size()) {
            out += ".";
          } else {
            out += ", ";
          }
        }
        response = 200;
      }
      req.sendResponseHeaders(response, out.length());
      OutputStream os = req.getResponseBody();
      os.write(out.getBytes());
      os.close();
    }
  }

}

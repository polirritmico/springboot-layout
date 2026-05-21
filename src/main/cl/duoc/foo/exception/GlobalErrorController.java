/*
 * Copyright © 2026 DuocUC FullStack 1
 * Eduardo Bray
 * Rodrigo Callealta
 * Fernando Villalobos
 */
package cl.duoc.foo.exception;

import cl.duoc.foo.exception.dto.ApiErrorResponse;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.boot.webmvc.error.ErrorController;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GlobalErrorController implements ErrorController {
    @RequestMapping("/error")
    public ResponseEntity<ApiErrorResponse> handleError(HttpServletResponse res) {
        return ResponseEntity.status(res.getStatus()).build();
    }
}

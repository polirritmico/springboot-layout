/*
 * Copyright © 2026 DuocUC FullStack 1
 * Eduardo Bray
 * Rodrigo Callealta
 * Fernando Villalobos
 */
package cl.duoc.foo.exception;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class FooNotFoundException extends RuntimeException {
    public FooNotFoundException(Long fooId) {
        String msg = "Foo with id '" + fooId + "' not found in the DB.";
        log.error(msg);
        super(msg);
    }
}

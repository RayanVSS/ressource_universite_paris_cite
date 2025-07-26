package client;

import logger.Logger;

import java.util.Scanner;

public class Client {
    public static void main(String[] args) {
        var logger = new Logger(new LogEntryConcreteFactory());
        try (var s = new Scanner(System.in)) {
            mainLoop:
            while (true) {
                System.out.print("> ");
                var entry = s.nextLine();
                switch (entry) {
                    case "" -> {
                        break mainLoop;
                    }
                    case "true" -> logger.log(true);
                    case "false" -> logger.log(false);
                    case "prettyprint" -> logger.printPrettyLog();
                    case "print" -> logger.printShortLog();
                    default -> {
                        try {
                            logger.log(Integer.parseInt(entry));
                        } catch (NumberFormatException e) {
                            System.out.println("Réessayer !");
                        }
                    }

                }
            }
        }
    }
}

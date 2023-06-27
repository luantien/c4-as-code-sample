workspace {
    model {
        # People/Actors
        # <variable> = person <name> <description> <tag>
        publicUser = person "Public User" "An anonymous user of the bookstore" "User"
        authorizedUser = person "Authorized User" "A registered user of the bookstore, with personal account" "User"

        # Software Systems
        # <variable> = softwareSystem <name> <description> <tag>
        bookstoreSystem = softwareSystem "iBookstore System" "Allows users to view about book, and administrate the book details" "Target System" {
            # Level 2: Containers
            # <variable> = container <name> <description> <technology> <tag>
            searchWebApi = container "Search Web API" "Allows only authorized users searching books records via HTTPS API" "Go"
            adminWebApi = container "Admin Web API" "Allows only authorized users administering books details via HTTPS API" "Go" {
                # Level 3: Components
                bookService = component "Book Service" "Allows administrating book details" "Go Service"
                authService = component "Authentication Service" "Authorize users by using external Authorization System" "Go Service"

            }
            publicWebApi = container "Public Web API" "Allows public users getting books information" "Go"
            searchDatabase = container "Search Database" "Stores searchable book information" "ElasticSearch" "Database"
            bookstoreDatabase = container "Bookstore Database" "Stores book details" "PostgreSQL" "Database"
        }
        
        # External Software Systems
        authSystem = softwareSystem "Authorization System" "The external Identiy Provider Platform" "External System"
        publisherSystem = softwareSystem "Publisher System" "The 3rd party system of publishers that gives details about books published by them" "External System"
        
        # Relationship between People and Software Systems
        # <variable> -> <variable> <description>
        publicUser -> bookstoreSystem "View book information"
        authorizedUser -> bookstoreSystem "Search book with more details, administrate books and their details"
        bookstoreSystem -> authSystem "Register new user, and authorize user access"
        publisherSystem -> bookstoreSystem "publish events for new book publication, and book information updates" {
            tags "Async Request"
        }

        # Relationship between Containers
        # customer -> singlePageApp "Views account balances, and makes payments using"
        # customer -> webApp "Visits bigbank.com/ib using" "HTTPS"
        # customer -> mobileApp "Views account balances, and makes payments using"
        # webApp -> singlePageApp "Delivers to the customer's web browser"
        # mobileApp -> apiApp "Makes API calls to [JSON/HTTPS]"
        # apiApp -> database "Reads from and writes to [JDBC]"
        # singlePageApp ->  apiApp "Makes API calls to [JSON/HTTPS]"

        # Relationship between Containers and External System
        # apiApp -> emailSys "Send email using" {
        #     tags "Async Request"
        # }
        # apiApp -> mainframeSys "Make API calls to [XML/HTTPS]"

        # Relationship between Components
        # signinController -> securityComponent "Uses"
        # accountsSummaryController -> mainframeBankingSystemFacade "Uses"
        # resetPasswordController -> securityComponent "Uses"
        # resetPasswordController -> emailComponent "Uses"
        # securityComponent -> database "Reads from and writes to" "JDBC"
        # mainframeBankingSystemFacade -> mainframeSys "Makes API calls to" "XML/HTTPS"
        # emailComponent -> emailSys "Sends e-mail using" {
        #     tags "Async Request"
        # }

        # Relationship between Components and Other Containers
        # singlePageApp -> signinController "Makes API calls to" "JSON/HTTPS"
        # singlePageApp -> accountsSummaryController "Makes API calls to" "JSON/HTTPS"
        # singlePageApp -> resetPasswordController "Makes API calls to" "JSON/HTTPS"
        # mobileApp -> signinController "Makes API calls to" "JSON/HTTPS"
        # mobileApp -> accountsSummaryController "Makes API calls to" "JSON/HTTPS"
        # mobileApp -> resetPasswordController "Makes API calls to" "JSON/HTTPS"

        # # Deployment for Dev Env
        # deploymentEnvironment "Development" {
        #     deploymentNode "Developer Laptop" "" "Microsoft Windows 10 or Apple macOS" {
        #         deploymentNode "Web Browser" "" "Chrome, Firefox, Safari, or Edge" {
        #             containerInstance singlePageApp
        #         }
        #         deploymentNode "Docker Container - Web Server" "" "Docker" {
        #             deploymentNode "Apache Tomcat" "" "Apache Tomcat 8.x" {
        #                 containerInstance webApp
        #                 containerInstance apiApp
        #             }
        #         }
        #         deploymentNode "Docker Container - Database Server" "" "Docker" {
        #             deploymentNode "Database Server" "" "Oracle 12c" {
        #                 containerInstance database
        #             }
        #         }
        #     }
        # }
    }

    views {
        # Level 1
        systemContext bookstoreSystem "SystemContext" {
            include *
            # default: tb,
            # support tb, bt, lr, rl
            autoLayout
        }
        # Level 2
        container bookstoreSystem "Containers" {
            include *
            autoLayout lr
        }
        # Level 3
        component adminWebApi "Components" {
            include *
            autoLayout
        }
        # deployment <software-system> <environment> <key> <description>
        # deployment iBankingSys "Development" "Dep-002-DEV" "Environment for Developer" {
        #     include *           
        #     autoLayout
        # }
        # dynamic apiApp "SignIn" "Summarises how the sign in feature works in the single-page application." {
        #     singlePageApp -> signinController "Submits credentials to"
        #     signinController -> securityComponent "Validates credentials using"
        #     securityComponent -> database "select * from users where username = ?"
        #     database -> securityComponent "Returns user data to"
        #     securityComponent -> signinController "Returns true if the hashed password matches"
        #     signinController -> singlePageApp "Sends back an authentication token to"
        #     autoLayout
        # }

        styles {
            # element <tag> {}
            element "Customer" {
                background #08427B
                color #ffffff
                fontSize 22
                shape Person
            }
            element "External System" {
                background #999999
                color #ffffff
            }
            relationship "Relationship" {
                dashed false
            }
            relationship "Async Request" {
                dashed true
            }
            element "Database" {
                shape Cylinder
            }
        }

        theme default
    }

}
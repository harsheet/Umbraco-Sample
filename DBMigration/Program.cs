using DbUp;
using DbUp.Helpers;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Xml.Linq;

namespace DBMigration
{
    class Program
    {
        private const string NodeName = "setParameter";
        private const string AttributeNameKey = "name";
        private const string AttributeNameValue = "value";
        private const string ConnectionStringKeyValueSuffix = "-Web.config Connection String";
        private const string MediaPath = "MediaPath";

        private static int Main(string[] args)
        {
            if (args == null || !args.Any())
            {
                Console.WriteLine("Please specify environment name.");
                Console.WriteLine("  -r - wipe and reset database");
                Console.WriteLine("  -nrs - no reseed.");

                return 0;
            }

            var lowerArgs = args
                .Select(a => a.ToLower())
                .ToArray();

            var environment = lowerArgs[0];

            var resetFlag = lowerArgs.Contains("-r");
            var noReseed = lowerArgs.Contains("-nrs");
            var addContent = lowerArgs.Contains("-c");

            if (addContent) resetFlag = true;

            Console.WriteLine("Environment: " + environment);
            Console.WriteLine("Reset: " + resetFlag);
            Console.WriteLine("No Reseed: " + noReseed);
            Console.WriteLine("Adding Content: " + addContent);

            // Get Connection Strings

            Console.WriteLine("Searching from: " + Directory.GetCurrentDirectory());
            var files = Directory.GetFiles(".\\", "Site.SetParameters." + environment + ".xml", SearchOption.AllDirectories);

            foreach (var xmlpath in files)
            {
                Console.WriteLine("Processing" + xmlpath);

                var xdoc = XDocument.Load(xmlpath);
                var connectionStrings = xdoc
                    .Descendants(NodeName)
                    .Where(a => a.Attribute(AttributeNameKey).Value.EndsWith(ConnectionStringKeyValueSuffix))
                    .ToDictionary(
                        a => a.Attribute(AttributeNameKey).Value.Replace(ConnectionStringKeyValueSuffix, ""),
                        a => a.Attribute(AttributeNameValue).Value);

                var mediaPath = xdoc
                    .Descendants(NodeName)
                    .Single(a => a.Attribute(AttributeNameKey).Value == MediaPath)
                    .Attribute(AttributeNameValue).Value;

                // Upgrade
                var assembly = typeof(Program).Assembly;
                var rootNamesapce = typeof(Program).Namespace;
                var reset = (rootNamesapce + ".scripts.clean.sql").ToLower();
                var reseed = (rootNamesapce + ".scripts.reseed.sql").ToLower();

                foreach (var connectionString in connectionStrings)
                {
                    var namespaceToFindScript = (rootNamesapce + ".scripts." + connectionString.Key).ToLower();
                    var namespaceToContentScript = (rootNamesapce + ".scripts.Content_" + connectionString.Key).ToLower();

                    if (resetFlag)
                    {
                        var resetter = DeployChanges.To
                            .SqlDatabase(connectionString.Value)
                            .WithScriptsEmbeddedInAssembly(
                                assembly, a => a.ToLower() == reset)
                            .JournalTo(new NullJournal())
                            .Build();

                        resetter.PerformUpgrade();
                    }

                    var engine = DeployChanges.To
                        .SqlDatabase(connectionString.Value);

                    if (!noReseed)
                        engine = engine.WithScriptsEmbeddedInAssembly(
                            assembly, a => a.ToLower() == reseed);

                    var upgrader = engine.WithScriptsEmbeddedInAssembly(
                        assembly, a => a.ToLower().StartsWith(namespaceToFindScript))
                        .LogToConsole()
                        .Build();

                    var result = upgrader.PerformUpgrade();

                    if (result.Successful && addContent)
                    {
                        var contentPushing = engine
                            .WithScriptsEmbeddedInAssembly(assembly, a => a.ToLower().StartsWith(namespaceToContentScript))
                            .WithVariables(new Dictionary<string, string>
                            {
                                {"MediaPath", mediaPath}
                            })
                            .LogToConsole()
                            .Build();

                        result = contentPushing.PerformUpgrade();
                    }

                    if (!result.Successful)
                    {
                        Console.ForegroundColor = ConsoleColor.Red;
                        Console.WriteLine(result.Error);
                        Console.ResetColor();
                        return -1;
                    }

                    Console.ForegroundColor = ConsoleColor.Green;
                    Console.WriteLine("Success!");
                    Console.ResetColor();
                }


            }
            return 0;
        }
    }
}

